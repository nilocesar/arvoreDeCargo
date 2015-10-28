package de.polygonal.ds
{
    import __AS3__.vec.*;
    import de.polygonal.ds.*;
    import flash.*;

    public class IntIntHashTableKeyIterator extends Object implements Itr
    {
        public var _s:int;
        public var _i:int;
        public var _f:Object;
        public var _data:Vector.<int>;

        public function IntIntHashTableKeyIterator(param1:Object = ) : void
        {
            if (Boot.skip_constructor)
            {
                return;
            }
            _f = param1;
            _data = _f._data;
            _i = 0;
            _s = _f._capacity;
            do
            {
                
                (_i + 1);
                if (_i < _s)
                {
                }
            }while (_data[_i * 3 + 1] == -2147483648)
            return;
        }// end function

        public function reset() : void
        {
            _data = _f._data;
            _i = 0;
            _s = _f._capacity;
            do
            {
                
                (_i + 1);
                if (_i < _s)
                {
                }
            }while (_data[_i * 3 + 1] == -2147483648)
            return;
        }// end function

        public function next() : Object
        {
            var _loc_2:* = _i;
            (_i + 1);
            var _loc_1:* = _data[_loc_2 * 3];
            do
            {
                
                (_i + 1);
                if (_i < _s)
                {
                }
            }while (_data[_i * 3 + 1] == -2147483648)
            return _loc_1;
        }// end function

        public function hasNext() : Boolean
        {
            return _i < _s;
        }// end function

        public function _scan() : void
        {
            do
            {
                
                (_i + 1);
                if (_i < _s)
                {
                }
            }while (_data[_i * 3 + 1] == -2147483648)
            return;
        }// end function

        public function __getData(param1:int) : int
        {
            return _data[param1];
        }// end function

    }
}
