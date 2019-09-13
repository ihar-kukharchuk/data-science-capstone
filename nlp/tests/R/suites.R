pacman::p_load("RUnit")

suite.00.utils <- RUnit::defineTestSuite("00-utils",
                                         dirs = file.path("tests", "R"),
                                         testFileRegexp = "^runit.+\\.R",
                                         testFuncRegexp = "^test.+",
                                         rngKind = "Marsaglia-Multicarry",
                                         rngNormalKind = "Kinderman-Ramage")
result.00.utils <- runTestSuite(suite.00.utils)
printTextProtocol(result.00.utils)