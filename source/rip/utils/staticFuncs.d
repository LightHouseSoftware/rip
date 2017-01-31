module rip.utils.staticFuncs;

static bool isGeneralOperation(string op) {
    switch (op)
    {
        case "+", "-", "*", "/", "%", "^^":
            return true;
        default:
            return false;
    }
}