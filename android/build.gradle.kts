import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory

// Root-level Gradle build file using Kotlin DSL

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Redirect root build dir to outside submodules (optional customization)
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

// Redirect build dirs of all subprojects
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

// Ensure ':app' is evaluated first
subprojects {
    project.evaluationDependsOn(":app")
}

// Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
