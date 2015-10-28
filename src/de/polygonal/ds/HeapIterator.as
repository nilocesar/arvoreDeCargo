package de.polygonal.ds
{
    import de.polygonal.ds.*;
    import flash.*;

    public class HeapIterator extends Object implements Itr
    {
        public var _s:int;
        public var _i:int;
        public var _f:Object;
        public var _a:Array;

        public function HeapIterator(param1:Object = ) : void
        {
            if (Boot.skip_constructor)
            {
                return;
            }
            _f = param1;
            reset();
            return;
        }// end function

        public function reset() : void
        {
            _a = _f._a;
            _s = _f._size + 1;
            _i = 1;
            return;
        }// end function

        public function next() : Object
        {
            var _loc_1:* = _i;
            (_i + 1);
            return _a[_loc_1];
        }// end function

        public function hasNext() : Boolean
        {
            return _i < _s;
        }// end function

    }
}
