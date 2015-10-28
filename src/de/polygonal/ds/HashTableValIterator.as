package de.polygonal.ds
{
    import de.polygonal.ds.*;
    import flash.*;

    public class HashTableValIterator extends Object implements Itr
    {
        public var _vals:Array;
        public var _s:int;
        public var _keys:Array;
        public var _i:int;
        public var _f:Object;

        public function HashTableValIterator(param1:Object = ) : void
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
            _vals = _f._vals;
            _keys = _f._keys;
            _i = -1;
            _s = _f._h._capacity;
            return;
        }// end function

        public function next() : Object
        {
            return _vals[_i];
        }// end function

        public function hasNext() : Boolean
        {
            var _loc_1:int = 0;
            do
            {
                
                if (_keys[_i] != null)
                {
                    return true;
                }
                ++_i;
            }while (++_i < _s)
            return false;
        }// end function

        public function __vals(param1:Object) : Array
        {
            return param1._vals;
        }// end function

        public function __keys(param1:Object) : Array
        {
            return param1._keys;
        }// end function

        public function __h(param1:Object) : IntIntHashTable
        {
            return param1._h;
        }// end function

    }
}
