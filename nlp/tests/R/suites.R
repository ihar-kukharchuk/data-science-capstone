pacman::p_load("RUnit")

suite.misc.utils <- RUnit::defineTestSuite(
    "misc-utils",
    dirs = file.path("tests", "R"),
    testFileRegexp = "^runit.+\\.R",
    testFuncRegexp = "^test.+",
    rngKind = "Marsaglia-Multicarry",
    rngNormalKind = "Kinderman-Ramage"
)
result.misc.utils <- runTestSuite(suite.misc.utils)
printTextProtocol(result.misc.utils)

suite.misc.settings <- RUnit::defineTestSuite(
    "misc-settings",
    dirs = file.path("tests", "R"),
    testFileRegexp = "^runit.+\\.R",
    testFuncRegexp = "^test.+",
    rngKind = "Marsaglia-Multicarry",
    rngNormalKind = "Kinderman-Ramage"
)
result.misc.settings <- runTestSuite(suite.misc.settings)
printTextProtocol(result.misc.settings)