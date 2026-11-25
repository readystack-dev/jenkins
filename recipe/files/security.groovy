// SECURITY BOOTSTRAP — NOT OPTIONAL.
//
// Booting offline requires -Djenkins.install.runSetupWizard=false, and that code path never
// calls SetupWizard.init(true) — the ONLY place that creates the security realm, the admin
// account and the authorization strategy. The result boots cleanly, passes a health check, and
// gives ANONYMOUS USERS FULL ADMIN. Upstream says so plainly: "Note that doing so leaves
// Jenkins unsecured." This script closes that hole: while Jenkins has no security realm it
// creates the administrator from JENKINS_ADMIN_PASSWORD, and without the variable it stops
// Jenkins. A realm that already exists (this one, LDAP, SAML, ...) is never touched.
//
// init.groovy.d is core Jenkins, so this needs no plugin and runs before the UI is reachable.
// The entrypoint refuses the same case before Java starts; this is the second line.
import jenkins.model.Jenkins
import hudson.security.SecurityRealm
import hudson.security.HudsonPrivateSecurityRealm
import hudson.security.FullControlOnceLoggedInAuthorizationStrategy

def inst = Jenkins.get()
def user = System.getenv('JENKINS_ADMIN_USER') ?: 'admin'
def pass = System.getenv('JENKINS_ADMIN_PASSWORD')

if (inst.getSecurityRealm() == SecurityRealm.NO_AUTHENTICATION) {
    if (!pass) {
        // Throwing would not help: Jenkins' GroovyHookScript catches it, logs 'Failed to run
        // script' and carries on unsecured. Halt the JVM so the container exits non-zero.
        System.err.println('security.groovy: JENKINS_ADMIN_PASSWORD is not set and Jenkins has no security realm: ' +
            'stopping Jenkins rather than running it unsecured. Set JENKINS_ADMIN_PASSWORD (and optionally ' +
            'JENKINS_ADMIN_USER) and start again.')
        System.err.flush()
        System.out.flush()
        Runtime.getRuntime().halt(1)
    }
    def realm = new HudsonPrivateSecurityRealm(false)
    realm.createAccount(user, pass)
    inst.setSecurityRealm(realm)

    def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
    strategy.setAllowAnonymousRead(false)
    inst.setAuthorizationStrategy(strategy)

    inst.save()
    println "security.groovy: created admin '${user}', anonymous read disabled"
} else {
    println 'security.groovy: security realm already configured, leaving it alone'
}
