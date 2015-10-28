package de.polygonal.core.util
{
    import de.polygonal.core.fmt.*;
    import flash.*;

    public class AssertionError extends Object
    {
        public var message:String;

        public function AssertionError(param1:String = , param2:Object = ) : void
        {
            if (Boot.skip_constructor)
            {
                return;
            }
            if (param2 == null)
            {
                message = Sprintf.format("Assertation \"%s\" failed", [param1]);
            }
            else
            {
                message = Sprintf.format("Assertation \"%s\" failed in file %s, line %d, %s::%s", [param1, param2.fileName, param2.lineNumber, param2.className, param2.methodName]);
            }
            return;
        }// end function

        public function toString() : String
        {
            return message;
        }// end function

    }
}
