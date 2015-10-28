package de.polygonal.ds
{
    import de.polygonal.core.fmt.*;
    import de.polygonal.core.util.*;
    import de.polygonal.ds.*;
    import flash.*;

    public class DA extends Object implements Collection
    {
        public var _size:int;
        public var _maxSize:int;
        public var _a:Array;

        public function DA(param1:int = 0, param2:int = -1) : void
        {
            var _loc_3:* = null as Array;
            if (Boot.skip_constructor)
            {
                return;
            }
            _size = 0;
            _maxSize = param2 == -1 ? (2147483647) : (param2);
            if (param1 > 0)
            {
                if (param1 > _maxSize)
                {
                    Boot.lastError = new Error();
                    throw new AssertionError("reserved size is greater than allowed size", {fileName:"DA.hx", lineNumber:80, className:"de.polygonal.ds.DA", methodName:"new"});
                }
                _loc_3 = new Array(param1);
                _a = _loc_3;
            }
            else
            {
                _a = [];
            }
            return;
        }// end function

        public function toString() : String
        {
            var _loc_4:int = 0;
            var _loc_1:* = Sprintf.format("\n{DA, size/max: %d/%d}", [_size, _maxSize]);
            if (_size == 0)
            {
                return _loc_1;
            }
            _loc_1 = _loc_1 + "\n|<\n";
            var _loc_2:int = 0;
            var _loc_3:* = _size;
            while (_loc_2 < _loc_3)
            {
                
                _loc_2++;
                _loc_4 = _loc_2;
                _loc_1 = _loc_1 + Sprintf.format("  %4d -> %s\n", [_loc_4, Std.string(_a[_loc_4])]);
            }
            _loc_1 = _loc_1 + ">|";
            return _loc_1;
        }// end function

        public function toDA() : DA
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_1:* = new DA(_size);
            var _loc_2:int = 0;
            var _loc_3:* = _size;
            while (_loc_2 < _loc_3)
            {
                
                _loc_2++;
                _loc_4 = _loc_2;
                _loc_5 = _loc_1._size;
                if (_loc_5 >= 0)
                {
                }
                if (_loc_5 > _loc_1._size)
                {
                    Boot.lastError = new Error();
                    throw new AssertionError(Sprintf.format("the index %d is out of range %d", [_loc_5, _loc_1._size]), {fileName:"DA.hx", lineNumber:157, className:"de.polygonal.ds.DA", methodName:"set"});
                }
                if (_loc_5 >= _loc_1._maxSize)
                {
                    Boot.lastError = new Error();
                    throw new AssertionError(Sprintf.format("size equals max size (%d)", [_loc_1._maxSize]), {fileName:"DA.hx", lineNumber:158, className:"de.polygonal.ds.DA", methodName:"set"});
                }
                _loc_1._a[_loc_5] = _a[_loc_4];
                if (_loc_5 >= _loc_1._size)
                {
                    (_loc_1._size + 1);
                }
            }
            return _loc_1;
        }// end function

        public function toArray() : Array
        {
            var _loc_5:int = 0;
            var _loc_2:* = new Array(_size);
            var _loc_1:* = _loc_2;
            var _loc_3:int = 0;
            var _loc_4:* = _size;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                _loc_1[_loc_5] = _a[_loc_5];
            }
            return _loc_1;
        }// end function

        public function swp(param1:int, param2:int) : void
        {
            if (param1 == param2)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("i index equals j index (%d)", [param1]), {fileName:"DA.hx", lineNumber:172, className:"de.polygonal.ds.DA", methodName:"swp"});
            }
            if (param1 >= 0)
            {
            }
            if (param1 >= _size)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("the index %d is out of range %d", [param1, (_size - 1)]), {fileName:"DA.hx", lineNumber:144, className:"de.polygonal.ds.DA", methodName:"get"});
            }
            var _loc_3:* = _a[param1];
            if (param1 == param2)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("i index equals j index (%d)", [param1]), {fileName:"DA.hx", lineNumber:187, className:"de.polygonal.ds.DA", methodName:"cpy"});
            }
            if (param1 >= 0)
            {
            }
            if (param1 > _size)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("the index %d is out of range %d", [param1, _size]), {fileName:"DA.hx", lineNumber:157, className:"de.polygonal.ds.DA", methodName:"set"});
            }
            if (param1 >= _maxSize)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("size equals max size (%d)", [_maxSize]), {fileName:"DA.hx", lineNumber:158, className:"de.polygonal.ds.DA", methodName:"set"});
            }
            if (param2 >= 0)
            {
            }
            if (param2 >= _size)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("the index %d is out of range %d", [param2, (_size - 1)]), {fileName:"DA.hx", lineNumber:144, className:"de.polygonal.ds.DA", methodName:"get"});
            }
            _a[param1] = _a[param2];
            if (param1 >= _size)
            {
                (_size + 1);
            }
            if (param2 >= 0)
            {
            }
            if (param2 > _size)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("the index %d is out of range %d", [param2, _size]), {fileName:"DA.hx", lineNumber:157, className:"de.polygonal.ds.DA", methodName:"set"});
            }
            if (param2 >= _maxSize)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("size equals max size (%d)", [_maxSize]), {fileName:"DA.hx", lineNumber:158, className:"de.polygonal.ds.DA", methodName:"set"});
            }
            _a[param2] = _loc_3;
            if (param2 >= _size)
            {
                (_size + 1);
            }
            return;
        }// end function

        public function swapWithBack(param1:int) : void
        {
            var _loc_3:* = null as Object;
            var _loc_4:int = 0;
            if (param1 >= 0)
            {
            }
            if (param1 >= _size)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("the index %d is out of range %d", [param1, _size]), {fileName:"DA.hx", lineNumber:301, className:"de.polygonal.ds.DA", methodName:"swapWithBack"});
            }
            var _loc_2:* = _size - 1;
            if (param1 < _loc_2)
            {
                _loc_4 = _size - 1;
                if (_loc_4 >= 0)
                {
                }
                if (_loc_4 >= _size)
                {
                    Boot.lastError = new Error();
                    throw new AssertionError(Sprintf.format("the index %d is out of range %d", [_loc_4, (_size - 1)]), {fileName:"DA.hx", lineNumber:144, className:"de.polygonal.ds.DA", methodName:"get"});
                }
                _loc_3 = _a[_loc_4];
                _a[_loc_2] = _a[param1];
                _a[param1] = _loc_3;
            }
            return;
        }// end function

        public function sort(param1:Function, param2:Boolean = false) : void
        {
            if (_size > 1)
            {
                if (param1 == null)
                {
                    if (param2)
                    {
                        _insertionSortComparable();
                    }
                    else
                    {
                        _quickSortComparable(0, _size);
                    }
                }
                else if (param2)
                {
                    _insertionSort(param1);
                }
                else
                {
                    _a.sort(param1);
                }
            }
            return;
        }// end function

        public function size() : int
        {
            return _size;
        }// end function

        public function shuffle(param1:DA = ) : void
        {
            var _loc_3:* = null as Class;
            var _loc_4:int = 0;
            var _loc_5:* = null as Object;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_2:* = _size;
            if (param1 == null)
            {
                _loc_3 = Math;
                do
                {
                    
                    _loc_4 = _loc_3.random() * _loc_2;
                    _loc_5 = _a[_loc_2];
                    _a[_loc_2] = _a[_loc_4];
                    _a[_loc_4] = _loc_5;
                    _loc_2--;
                }while (_loc_2 > 1)
            }
            else
            {
                if (param1 == null)
                {
                    Boot.lastError = new Error();
                    throw new AssertionError("rval is null", {fileName:"DA.hx", lineNumber:760, className:"de.polygonal.ds.DA", methodName:"shuffle"});
                }
                if (param1._size < _size)
                {
                    Boot.lastError = new Error();
                    throw new AssertionError("insufficient random values", {fileName:"DA.hx", lineNumber:761, className:"de.polygonal.ds.DA", methodName:"shuffle"});
                }
                _loc_4 = 0;
                do
                {
                    
                    _loc_4++;
                    _loc_7 = _loc_4;
                    if (_loc_7 >= 0)
                    {
                    }
                    if (_loc_7 >= param1._size)
                    {
                        Boot.lastError = new Error();
                        throw new AssertionError(Sprintf.format("the index %d is out of range %d", [_loc_7, (param1._size - 1)]), {fileName:"DA.hx", lineNumber:144, className:"de.polygonal.ds.DA", methodName:"get"});
                    }
                    _loc_6 = param1._a[_loc_7] * _loc_2;
                    _loc_5 = _a[_loc_2];
                    _a[_loc_2] = _a[_loc_6];
                    _a[_loc_6] = _loc_5;
                    _loc_2--;
                }while (_loc_2 > 1)
            }
            return;
        }// end function

        public function set(param1:int, param2:Object) : void
        {
            if (param1 >= 0)
            {
            }
            if (param1 > _size)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("the index %d is out of range %d", [param1, _size]), {fileName:"DA.hx", lineNumber:157, className:"de.polygonal.ds.DA", methodName:"set"});
            }
            if (param1 >= _maxSize)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("size equals max size (%d)", [_maxSize]), {fileName:"DA.hx", lineNumber:158, className:"de.polygonal.ds.DA", methodName:"set"});
            }
            _a[param1] = param2;
            if (param1 >= _size)
            {
                (_size + 1);
            }
            return;
        }// end function

        public function reverse() : void
        {
            var _loc_3:int = 0;
            _a.reverse();
            var _loc_1:* = _a.length - _size;
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_2++;
                _loc_3 = _loc_2;
                _a[_loc_3] = _a[_loc_3 + _loc_1];
            }
            return;
        }// end function

        public function reserve(param1:int) : void
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            if (_size == param1)
            {
                return;
            }
            var _loc_2:* = _a;
            var _loc_3:* = new Array(param1);
            _a = _loc_3;
            if (_size < param1)
            {
                _loc_4 = 0;
                _loc_5 = _size;
                while (_loc_4 < _loc_5)
                {
                    
                    _loc_4++;
                    _loc_6 = _loc_4;
                    _a[_loc_6] = _loc_2[_loc_6];
                }
            }
            return;
        }// end function

        public function removeRange(param1:int, param2:int, param3:DA = ) : DA
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:* = null as Object;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            if (param1 >= 0)
            {
            }
            if (param1 > _size)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("i index out of range (%d)", [param1]), {fileName:"DA.hx", lineNumber:323, className:"de.polygonal.ds.DA", methodName:"removeRange"});
            }
            if (param2 > 0)
            {
                if (param2 <= _size)
                {
                }
            }
            if (param1 + param2 > _size)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("n out of range (%d)", [param2]), {fileName:"DA.hx", lineNumber:324, className:"de.polygonal.ds.DA", methodName:"removeRange"});
            }
            if (param3 == null)
            {
                _loc_4 = _size;
                _loc_5 = param1 + param2;
                while (_loc_5 < _loc_4)
                {
                    
                    _loc_5++;
                    _a[_loc_5 - param2] = _a[_loc_5];
                }
            }
            else
            {
                _loc_4 = _size;
                _loc_5 = param1 + param2;
                while (_loc_5 < _loc_4)
                {
                    
                    _loc_7 = _loc_5 - param2;
                    _loc_6 = _a[_loc_7];
                    _loc_8 = param3._size;
                    if (_loc_8 >= 0)
                    {
                    }
                    if (_loc_8 > param3._size)
                    {
                        Boot.lastError = new Error();
                        throw new AssertionError(Sprintf.format("the index %d is out of range %d", [_loc_8, param3._size]), {fileName:"DA.hx", lineNumber:157, className:"de.polygonal.ds.DA", methodName:"set"});
                    }
                    if (_loc_8 >= param3._maxSize)
                    {
                        Boot.lastError = new Error();
                        throw new AssertionError(Sprintf.format("size equals max size (%d)", [param3._maxSize]), {fileName:"DA.hx", lineNumber:158, className:"de.polygonal.ds.DA", methodName:"set"});
                    }
                    param3._a[_loc_8] = _loc_6;
                    if (_loc_8 >= param3._size)
                    {
                        (param3._size + 1);
                    }
                    _loc_5++;
                    _a[_loc_7] = _a[_loc_5];
                }
            }
            _size = _size - param2;
            return param3;
        }// end function

        public function removeAt(param1:int) : Object
        {
            if (param1 >= 0)
            {
            }
            if (param1 >= _size)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("the index %d is out of range %d", [param1, _size]), {fileName:"DA.hx", lineNumber:282, className:"de.polygonal.ds.DA", methodName:"removeAt"});
            }
            var _loc_2:* = _a[param1];
            var _loc_3:* = _size - 1;
            var _loc_4:* = param1;
            while (_loc_4 < _loc_3)
            {
                
                _loc_4++;
                _a[_loc_4] = _a[_loc_4];
            }
            (_size - 1);
            return _loc_2;
        }// end function

        public function remove(param1:Object) : Boolean
        {
            var _loc_4:int = 0;
            if (_size == 0)
            {
                return false;
            }
            var _loc_2:int = 0;
            var _loc_3:* = _size;
            while (_loc_2 < _loc_3)
            {
                
                if (_a[_loc_2] == param1)
                {
                    _loc_3--;
                    _loc_4 = _loc_2;
                    while (_loc_4 < _loc_3)
                    {
                        
                        _loc_4++;
                        _a[_loc_4] = _a[_loc_4];
                    }
                    continue;
                }
                _loc_2++;
            }
            var _loc_5:* = _size - _loc_3 != 0;
            _size = _loc_3;
            return _loc_5;
        }// end function

        public function pushFront(param1:Object) : void
        {
            if (_maxSize != -1)
            {
                if (_size >= _maxSize)
                {
                    Boot.lastError = new Error();
                    throw new AssertionError(Sprintf.format("size equals max size (%d)", [_maxSize]), {fileName:"DA.hx", lineNumber:250, className:"de.polygonal.ds.DA", methodName:"pushFront"});
                }
            }
            if (_size >= _maxSize)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("size equals max size (%d)", [_maxSize]), {fileName:"DA.hx", lineNumber:264, className:"de.polygonal.ds.DA", methodName:"insertAt"});
            }
            if (_size < 0)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("i index out of range (%d)", [0]), {fileName:"DA.hx", lineNumber:265, className:"de.polygonal.ds.DA", methodName:"insertAt"});
            }
            var _loc_2:* = _size;
            while (_loc_2 > 0)
            {
                
                _loc_2--;
                _a[_loc_2] = _a[_loc_2];
            }
            _a[0] = param1;
            (_size + 1);
            return;
        }// end function

        public function pushBack(param1:Object) : void
        {
            var _loc_2:* = _size;
            if (_loc_2 >= 0)
            {
            }
            if (_loc_2 > _size)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("the index %d is out of range %d", [_loc_2, _size]), {fileName:"DA.hx", lineNumber:157, className:"de.polygonal.ds.DA", methodName:"set"});
            }
            if (_loc_2 >= _maxSize)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("size equals max size (%d)", [_maxSize]), {fileName:"DA.hx", lineNumber:158, className:"de.polygonal.ds.DA", methodName:"set"});
            }
            _a[_loc_2] = param1;
            if (_loc_2 >= _size)
            {
                (_size + 1);
            }
            return;
        }// end function

        public function popFront() : Object
        {
            if (_size <= 0)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("the index %d is out of range %d", [0, _size]), {fileName:"DA.hx", lineNumber:282, className:"de.polygonal.ds.DA", methodName:"removeAt"});
            }
            var _loc_1:* = _a[0];
            var _loc_2:* = _size - 1;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_3++;
                _a[_loc_3] = _a[_loc_3];
            }
            (_size - 1);
            return _loc_1;
        }// end function

        public function popBack() : Object
        {
            var _loc_2:* = _size - 1;
            if (_loc_2 >= 0)
            {
            }
            if (_loc_2 >= _size)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("the index %d is out of range %d", [_loc_2, (_size - 1)]), {fileName:"DA.hx", lineNumber:144, className:"de.polygonal.ds.DA", methodName:"get"});
            }
            var _loc_1:* = _a[_loc_2];
            (_size - 1);
            return _loc_1;
        }// end function

        public function pack() : void
        {
            var _loc_6:int = 0;
            var _loc_1:* = _a.length;
            if (_loc_1 == _size)
            {
                return;
            }
            var _loc_2:* = _a;
            var _loc_3:* = new Array(_size);
            _a = _loc_3;
            var _loc_4:int = 0;
            var _loc_5:* = _size;
            while (_loc_4 < _loc_5)
            {
                
                _loc_4++;
                _loc_6 = _loc_4;
                _a[_loc_6] = _loc_2[_loc_6];
            }
            _loc_4 = _size;
            _loc_5 = _loc_2.length;
            while (_loc_4 < _loc_5)
            {
                
                _loc_4++;
                _loc_6 = _loc_4;
                _loc_2[_loc_6] = null;
            }
            return;
        }// end function

        public function move(param1:int, param2:int, param3:int) : void
        {
            if (param3 < 0)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("n invalid (%d)", [param3]), {fileName:"DA.hx", lineNumber:517, className:"de.polygonal.ds.DA", methodName:"move"});
            }
            if (param1 >= 0)
            {
            }
            if (param1 > _size - param3)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("destination invalid (%d)", [param1]), {fileName:"DA.hx", lineNumber:518, className:"de.polygonal.ds.DA", methodName:"move"});
            }
            if (param2 >= 0)
            {
            }
            if (param2 > _size - param3)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("source invalid (%d)", [param2]), {fileName:"DA.hx", lineNumber:519, className:"de.polygonal.ds.DA", methodName:"move"});
            }
            if (param1 == param2)
            {
                return;
            }
            else
            {
                if (param2 < param1)
                {
                }
                if (param1 < param2 + param3)
                {
                    param2 = param2 + param3;
                    param1 = param1 + param3;
                    do
                    {
                        
                        param1--;
                        param2--;
                        _a[param1] = _a[param2];
                        param3--;
                    }while (param3 > 0)
                }
                else
                {
                    do
                    {
                        
                        param1++;
                        param2++;
                        _a[param1] = _a[param2];
                        param3--;
                    }while (param3 > 0)
                }
            }
            return;
        }// end function

        public function maxSize() : int
        {
            return _maxSize;
        }// end function

        public function lastIndexOf(param1:Object, param2:int = -1) : int
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            if (_size == 0)
            {
                return -1;
            }
            else
            {
                if (param2 < 0)
                {
                    param2 = _size + param2;
                }
                if (param2 >= 0)
                {
                }
                if (param2 >= _size)
                {
                    Boot.lastError = new Error();
                    throw new AssertionError(Sprintf.format("from index out of range (%d)", [param2]), {fileName:"DA.hx", lineNumber:431, className:"de.polygonal.ds.DA", methodName:"lastIndexOf"});
                }
                _loc_3 = -1;
                _loc_4 = param2;
                do
                {
                    
                    if (_a[_loc_4] == param1)
                    {
                        _loc_3 = _loc_4;
                        break;
                    }
                    _loc_4--;
                }while (_loc_4 > 0)
                return _loc_3;
            }
        }// end function

        public function join(param1:String) : String
        {
            var _loc_5:int = 0;
            if (_size == 0)
            {
                return "";
            }
            if (_size == 1)
            {
                if (_size <= 0)
                {
                    Boot.lastError = new Error();
                    throw new AssertionError(Sprintf.format("the index %d is out of range %d", [0, (_size - 1)]), {fileName:"DA.hx", lineNumber:144, className:"de.polygonal.ds.DA", methodName:"get"});
                }
                return Std.string(_a[0]);
            }
            if (_size <= 0)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("the index %d is out of range %d", [0, (_size - 1)]), {fileName:"DA.hx", lineNumber:144, className:"de.polygonal.ds.DA", methodName:"get"});
            }
            var _loc_2:* = Std.string(_a[0]) + param1;
            var _loc_3:int = 1;
            var _loc_4:* = _size - 1;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                if (_loc_5 >= 0)
                {
                }
                if (_loc_5 >= _size)
                {
                    Boot.lastError = new Error();
                    throw new AssertionError(Sprintf.format("the index %d is out of range %d", [_loc_5, (_size - 1)]), {fileName:"DA.hx", lineNumber:144, className:"de.polygonal.ds.DA", methodName:"get"});
                }
                _loc_2 = _loc_2 + Std.string(_a[_loc_5]);
                _loc_2 = _loc_2 + param1;
            }
            _loc_3 = _size - 1;
            if (_loc_3 >= 0)
            {
            }
            if (_loc_3 >= _size)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("the index %d is out of range %d", [_loc_3, (_size - 1)]), {fileName:"DA.hx", lineNumber:144, className:"de.polygonal.ds.DA", methodName:"get"});
            }
            _loc_2 = _loc_2 + Std.string(_a[_loc_3]);
            return _loc_2;
        }// end function

        public function iterator() : Itr
        {
            return new DAIterator(this);
        }// end function

        public function isEmpty() : Boolean
        {
            return _size == 0;
        }// end function

        public function insertAt(param1:int, param2:Object) : void
        {
            if (_size >= _maxSize)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("size equals max size (%d)", [_maxSize]), {fileName:"DA.hx", lineNumber:264, className:"de.polygonal.ds.DA", methodName:"insertAt"});
            }
            if (param1 >= 0)
            {
            }
            if (param1 > _size)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("i index out of range (%d)", [param1]), {fileName:"DA.hx", lineNumber:265, className:"de.polygonal.ds.DA", methodName:"insertAt"});
            }
            var _loc_3:* = _size;
            while (_loc_3 > param1)
            {
                
                _loc_3--;
                _a[_loc_3] = _a[_loc_3];
            }
            _a[param1] = param2;
            (_size + 1);
            return;
        }// end function

        public function indexOf(param1:Object, param2:int = 0) : int
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            if (_size == 0)
            {
                return -1;
            }
            else
            {
                if (param2 >= 0)
                {
                }
                if (param2 >= _size)
                {
                    Boot.lastError = new Error();
                    throw new AssertionError(Sprintf.format("from index out of range (%d)", [param2]), {fileName:"DA.hx", lineNumber:397, className:"de.polygonal.ds.DA", methodName:"indexOf"});
                }
                _loc_3 = -1;
                _loc_4 = param2;
                _loc_5 = _size - 1;
                do
                {
                    
                    if (_a[_loc_4] == param1)
                    {
                        _loc_3 = _loc_4;
                        break;
                    }
                    _loc_4++;
                }while (_loc_4 < _loc_5)
                return _loc_3;
            }
        }// end function

        public function get(param1:int) : Object
        {
            if (param1 >= 0)
            {
            }
            if (param1 >= _size)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("the index %d is out of range %d", [param1, (_size - 1)]), {fileName:"DA.hx", lineNumber:144, className:"de.polygonal.ds.DA", methodName:"get"});
            }
            return _a[param1];
        }// end function

        public function front() : Object
        {
            if (_size <= 0)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("the index %d is out of range %d", [0, (_size - 1)]), {fileName:"DA.hx", lineNumber:144, className:"de.polygonal.ds.DA", methodName:"get"});
            }
            return _a[0];
        }// end function

        public function free() : void
        {
            var _loc_4:int = 0;
            var _loc_1:Object = null;
            var _loc_2:int = 0;
            var _loc_3:* = _a.length;
            while (_loc_2 < _loc_3)
            {
                
                _loc_2++;
                _loc_4 = _loc_2;
                _a[_loc_4] = _loc_1;
            }
            _a = null;
            return;
        }// end function

        public function fill(param1:Object, param2:int = 0) : void
        {
            var _loc_4:int = 0;
            if (param2 == 0)
            {
                param2 = _size;
            }
            else
            {
                if (param2 > _maxSize)
                {
                    Boot.lastError = new Error();
                    throw new AssertionError(Sprintf.format("limit out of range (%d)", [param2]), {fileName:"DA.hx", lineNumber:498, className:"de.polygonal.ds.DA", methodName:"fill"});
                }
                _size = param2;
            }
            var _loc_3:int = 0;
            while (_loc_3 < param2)
            {
                
                _loc_3++;
                _loc_4 = _loc_3;
                _a[_loc_4] = param1;
            }
            return;
        }// end function

        public function cpy(param1:int, param2:int) : void
        {
            if (param1 == param2)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("i index equals j index (%d)", [param1]), {fileName:"DA.hx", lineNumber:187, className:"de.polygonal.ds.DA", methodName:"cpy"});
            }
            if (param1 >= 0)
            {
            }
            if (param1 > _size)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("the index %d is out of range %d", [param1, _size]), {fileName:"DA.hx", lineNumber:157, className:"de.polygonal.ds.DA", methodName:"set"});
            }
            if (param1 >= _maxSize)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("size equals max size (%d)", [_maxSize]), {fileName:"DA.hx", lineNumber:158, className:"de.polygonal.ds.DA", methodName:"set"});
            }
            if (param2 >= 0)
            {
            }
            if (param2 >= _size)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("the index %d is out of range %d", [param2, (_size - 1)]), {fileName:"DA.hx", lineNumber:144, className:"de.polygonal.ds.DA", methodName:"get"});
            }
            _a[param1] = _a[param2];
            if (param1 >= _size)
            {
                (_size + 1);
            }
            return;
        }// end function

        public function contains(param1:Object) : Boolean
        {
            var _loc_5:int = 0;
            var _loc_2:Boolean = false;
            var _loc_3:int = 0;
            var _loc_4:* = _size;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                if (_a[_loc_5] == param1)
                {
                    _loc_2 = true;
                    break;
                }
            }
            return _loc_2;
        }// end function

        public function concat(param1:DA, param2:Boolean = false) : DA
        {
            var _loc_3:* = null as DA;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            if (param1 == null)
            {
                Boot.lastError = new Error();
                throw new AssertionError("x is null", {fileName:"DA.hx", lineNumber:360, className:"de.polygonal.ds.DA", methodName:"concat"});
            }
            if (param2)
            {
                _loc_3 = new DA();
                _loc_3._size = _size + param1._size;
                _loc_4 = 0;
                _loc_5 = _size;
                while (_loc_4 < _loc_5)
                {
                    
                    _loc_4++;
                    _loc_6 = _loc_4;
                    if (_loc_6 >= 0)
                    {
                    }
                    if (_loc_6 > _loc_3._size)
                    {
                        Boot.lastError = new Error();
                        throw new AssertionError(Sprintf.format("the index %d is out of range %d", [_loc_6, _loc_3._size]), {fileName:"DA.hx", lineNumber:157, className:"de.polygonal.ds.DA", methodName:"set"});
                    }
                    if (_loc_6 >= _loc_3._maxSize)
                    {
                        Boot.lastError = new Error();
                        throw new AssertionError(Sprintf.format("size equals max size (%d)", [_loc_3._maxSize]), {fileName:"DA.hx", lineNumber:158, className:"de.polygonal.ds.DA", methodName:"set"});
                    }
                    _loc_3._a[_loc_6] = _a[_loc_6];
                    if (_loc_6 >= _loc_3._size)
                    {
                        (_loc_3._size + 1);
                    }
                }
                _loc_4 = _size;
                _loc_5 = _size + param1._size;
                while (_loc_4 < _loc_5)
                {
                    
                    _loc_4++;
                    _loc_6 = _loc_4;
                    if (_loc_6 >= 0)
                    {
                    }
                    if (_loc_6 > _loc_3._size)
                    {
                        Boot.lastError = new Error();
                        throw new AssertionError(Sprintf.format("the index %d is out of range %d", [_loc_6, _loc_3._size]), {fileName:"DA.hx", lineNumber:157, className:"de.polygonal.ds.DA", methodName:"set"});
                    }
                    if (_loc_6 >= _loc_3._maxSize)
                    {
                        Boot.lastError = new Error();
                        throw new AssertionError(Sprintf.format("size equals max size (%d)", [_loc_3._maxSize]), {fileName:"DA.hx", lineNumber:158, className:"de.polygonal.ds.DA", methodName:"set"});
                    }
                    _loc_7 = _loc_6 - _size;
                    if (_loc_7 >= 0)
                    {
                    }
                    if (_loc_7 >= param1._size)
                    {
                        Boot.lastError = new Error();
                        throw new AssertionError(Sprintf.format("the index %d is out of range %d", [_loc_7, (param1._size - 1)]), {fileName:"DA.hx", lineNumber:144, className:"de.polygonal.ds.DA", methodName:"get"});
                    }
                    _loc_3._a[_loc_6] = param1._a[_loc_7];
                    if (_loc_6 >= _loc_3._size)
                    {
                        (_loc_3._size + 1);
                    }
                }
                return _loc_3;
            }
            else
            {
                if (param1 == this)
                {
                    Boot.lastError = new Error();
                    throw new AssertionError("x equals this", {fileName:"DA.hx", lineNumber:374, className:"de.polygonal.ds.DA", methodName:"concat"});
                }
                _loc_4 = _size;
                _size = _size + param1._size;
                _loc_5 = 0;
                _loc_6 = param1._size;
                while (_loc_5 < _loc_6)
                {
                    
                    _loc_5++;
                    _loc_7 = _loc_5;
                    _loc_4++;
                    if (_loc_7 >= 0)
                    {
                    }
                    if (_loc_7 >= param1._size)
                    {
                        Boot.lastError = new Error();
                        throw new AssertionError(Sprintf.format("the index %d is out of range %d", [_loc_7, (param1._size - 1)]), {fileName:"DA.hx", lineNumber:144, className:"de.polygonal.ds.DA", methodName:"get"});
                    }
                    _a[_loc_4] = param1._a[_loc_7];
                }
                return this;
            }
        }// end function

        public function clone(param1:Boolean, param2:Object = ) : Collection
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:* = null as Cloneable;
            var _loc_3:* = new DA();
            _loc_3._size = _size;
            if (param1)
            {
                _loc_4 = 0;
                _loc_5 = _size;
                while (_loc_4 < _loc_5)
                {
                    
                    _loc_4++;
                    _loc_6 = _loc_4;
                    _loc_3._a[_loc_6] = _a[_loc_6];
                }
            }
            else if (param2 == null)
            {
                _loc_7 = null;
                _loc_4 = 0;
                _loc_5 = _size;
                while (_loc_4 < _loc_5)
                {
                    
                    _loc_4++;
                    _loc_6 = _loc_4;
                    if (!Std.is(_a[_loc_6], Cloneable))
                    {
                        Boot.lastError = new Error();
                        throw new AssertionError(Sprintf.format("element is not of type Cloneable (%s)", [_a[_loc_6]]), {fileName:"DA.hx", lineNumber:721, className:"de.polygonal.ds.DA", methodName:"clone"});
                    }
                    _loc_7 = _a[_loc_6];
                    _loc_3._a[_loc_6] = _loc_7.clone();
                }
            }
            else
            {
                _loc_4 = 0;
                _loc_5 = _size;
                while (_loc_4 < _loc_5)
                {
                    
                    _loc_4++;
                    _loc_6 = _loc_4;
                    _loc_3._a[_loc_6] = this.param2(_a[_loc_6]);
                }
            }
            return _loc_3;
        }// end function

        public function clear(param1:Boolean = false) : void
        {
            var _loc_2:* = null as Object;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            if (param1)
            {
                _loc_2 = null;
                _loc_3 = 0;
                _loc_4 = _a.length;
                while (_loc_3 < _loc_4)
                {
                    
                    _loc_3++;
                    _loc_5 = _loc_3;
                    _a[_loc_5] = _loc_2;
                }
            }
            _size = 0;
            return;
        }// end function

        public function back() : Object
        {
            var _loc_1:* = _size - 1;
            if (_loc_1 >= 0)
            {
            }
            if (_loc_1 >= _size)
            {
                Boot.lastError = new Error();
                throw new AssertionError(Sprintf.format("the index %d is out of range %d", [_loc_1, (_size - 1)]), {fileName:"DA.hx", lineNumber:144, className:"de.polygonal.ds.DA", methodName:"get"});
            }
            return _a[_loc_1];
        }// end function

        public function assign(param1:Class, param2:Array = , param3:int = 0) : void
        {
            var _loc_5:int = 0;
            if (param3 == 0)
            {
                param3 = _size;
            }
            else
            {
                if (param3 > _maxSize)
                {
                    Boot.lastError = new Error();
                    throw new AssertionError(Sprintf.format("limit out of range (%d)", [param3]), {fileName:"DA.hx", lineNumber:476, className:"de.polygonal.ds.DA", methodName:"assign"});
                }
                _size = param3;
            }
            if (param2 == null)
            {
                param2 = [];
            }
            var _loc_4:int = 0;
            while (_loc_4 < param3)
            {
                
                _loc_4++;
                _loc_5 = _loc_4;
                _a[_loc_5] = Type.createInstance(param1, param2);
            }
            return;
        }// end function

        public function _quickSortComparable(param1:int, param2:int) : void
        {
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:* = null as Object;
            var _loc_10:* = null as Object;
            var _loc_11:* = null as Object;
            var _loc_12:int = 0;
            var _loc_13:int = 0;
            var _loc_14:* = null as Object;
            var _loc_3:* = param1 + param2 - 1;
            var _loc_4:* = param1;
            var _loc_5:* = _loc_3;
            if (param2 > 1)
            {
                _loc_6 = param1;
                _loc_7 = _loc_6 + (param2 >> 1);
                _loc_8 = _loc_6 + param2 - 1;
                _loc_9 = _a[_loc_6];
                _loc_10 = _a[_loc_7];
                _loc_11 = _a[_loc_8];
                if (!Std.is(_loc_9, Comparable))
                {
                    Boot.lastError = new Error();
                    throw new AssertionError(Sprintf.format("element is not of type Comparable (%s)", [Std.string(_loc_9)]), {fileName:"DA.hx", lineNumber:871, className:"de.polygonal.ds.DA", methodName:"_quickSortComparable"});
                }
                if (!Std.is(_loc_10, Comparable))
                {
                    Boot.lastError = new Error();
                    throw new AssertionError(Sprintf.format("element is not of type Comparable (%s)", [Std.string(_loc_10)]), {fileName:"DA.hx", lineNumber:872, className:"de.polygonal.ds.DA", methodName:"_quickSortComparable"});
                }
                if (!Std.is(_loc_11, Comparable))
                {
                    Boot.lastError = new Error();
                    throw new AssertionError(Sprintf.format("element is not of type Comparable (%s)", [Std.string(_loc_11)]), {fileName:"DA.hx", lineNumber:873, className:"de.polygonal.ds.DA", methodName:"_quickSortComparable"});
                }
                _loc_13 = _loc_9.compare(_loc_11);
                if (_loc_13 < 0)
                {
                }
                if (_loc_9.compare(_loc_10) < 0)
                {
                    _loc_12 = _loc_10.compare(_loc_11) < 0 ? (_loc_7) : (_loc_8);
                }
                else
                {
                    if (_loc_9.compare(_loc_10) < 0)
                    {
                    }
                    if (_loc_10.compare(_loc_11) < 0)
                    {
                        _loc_12 = _loc_13 < 0 ? (_loc_6) : (_loc_8);
                    }
                    else
                    {
                        _loc_12 = _loc_11.compare(_loc_9) < 0 ? (_loc_7) : (_loc_6);
                    }
                }
                _loc_14 = _a[_loc_12];
                _a[_loc_12] = _a[param1];
                while (_loc_4 < _loc_5)
                {
                    
                    if (!Std.is(_a[_loc_4], Comparable))
                    {
                        Boot.lastError = new Error();
                        throw new AssertionError(Sprintf.format("element is not of type Comparable (%s)", [Std.string(_a[_loc_4])]), {fileName:"DA.hx", lineNumber:894, className:"de.polygonal.ds.DA", methodName:"_quickSortComparable"});
                    }
                    if (!Std.is(_a[_loc_5], Comparable))
                    {
                        Boot.lastError = new Error();
                        throw new AssertionError(Sprintf.format("element is not of type Comparable (%s)", [Std.string(_a[_loc_5])]), {fileName:"DA.hx", lineNumber:895, className:"de.polygonal.ds.DA", methodName:"_quickSortComparable"});
                    }
                    if (!Std.is(_loc_14, Comparable))
                    {
                        Boot.lastError = new Error();
                        throw new AssertionError(Sprintf.format("element is not of type Comparable (%s)", [Std.string(_loc_14)]), {fileName:"DA.hx", lineNumber:896, className:"de.polygonal.ds.DA", methodName:"_quickSortComparable"});
                    }
                    do
                    {
                        
                        _loc_5--;
                        if (_loc_14.compare(_a[_loc_5]) < 0)
                        {
                        }
                    }while (_loc_4 < _loc_5)
                    if (_loc_5 != _loc_4)
                    {
                        _a[_loc_4] = _a[_loc_5];
                        _loc_4++;
                    }
                    do
                    {
                        
                        _loc_4++;
                        if (_loc_14.compare(_a[_loc_4]) > 0)
                        {
                        }
                    }while (_loc_4 < _loc_5)
                    if (_loc_5 != _loc_4)
                    {
                        _a[_loc_5] = _a[_loc_4];
                        _loc_5--;
                    }
                }
                _a[_loc_4] = _loc_14;
                _quickSortComparable(param1, _loc_4 - param1);
                _quickSortComparable((_loc_4 + 1), _loc_3 - _loc_4);
            }
            return;
        }// end function

        public function _quickSort(param1:int, param2:int, param3:Function) : void
        {
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            var _loc_10:* = null as Object;
            var _loc_11:* = null as Object;
            var _loc_12:* = null as Object;
            var _loc_13:int = 0;
            var _loc_14:int = 0;
            var _loc_15:* = null as Object;
            var _loc_4:* = param1 + param2 - 1;
            var _loc_5:* = param1;
            var _loc_6:* = _loc_4;
            if (param2 > 1)
            {
                _loc_7 = param1;
                _loc_8 = _loc_7 + (param2 >> 1);
                _loc_9 = _loc_7 + param2 - 1;
                _loc_10 = _a[_loc_7];
                _loc_11 = _a[_loc_8];
                _loc_12 = _a[_loc_9];
                _loc_14 = this.param3(_loc_10, _loc_12);
                if (_loc_14 < 0)
                {
                }
                if (this.param3(_loc_10, _loc_11) < 0)
                {
                    _loc_13 = this.param3(_loc_11, _loc_12) < 0 ? (_loc_8) : (_loc_9);
                }
                else
                {
                    if (this.param3(_loc_11, _loc_10) < 0)
                    {
                    }
                    if (this.param3(_loc_11, _loc_12) < 0)
                    {
                        _loc_13 = _loc_14 < 0 ? (_loc_7) : (_loc_9);
                    }
                    else
                    {
                        _loc_13 = this.param3(_loc_12, _loc_10) < 0 ? (_loc_8) : (_loc_7);
                    }
                }
                _loc_15 = _a[_loc_13];
                _a[_loc_13] = _a[param1];
                while (_loc_5 < _loc_6)
                {
                    
                    do
                    {
                        
                        _loc_6--;
                        if (this.param3(_loc_15, _a[_loc_6]) < 0)
                        {
                        }
                    }while (_loc_5 < _loc_6)
                    if (_loc_6 != _loc_5)
                    {
                        _a[_loc_5] = _a[_loc_6];
                        _loc_5++;
                    }
                    do
                    {
                        
                        _loc_5++;
                        if (this.param3(_loc_15, _a[_loc_5]) > 0)
                        {
                        }
                    }while (_loc_5 < _loc_6)
                    if (_loc_6 != _loc_5)
                    {
                        _a[_loc_6] = _a[_loc_5];
                        _loc_6--;
                    }
                }
                _a[_loc_5] = _loc_15;
                _quickSort(param1, _loc_5 - param1, param3);
                _quickSort((_loc_5 + 1), _loc_4 - _loc_5, param3);
            }
            return;
        }// end function

        public function _insertionSortComparable() : void
        {
            var _loc_3:int = 0;
            var _loc_4:* = null as Object;
            var _loc_5:int = 0;
            var _loc_6:* = null as Object;
            var _loc_1:int = 1;
            var _loc_2:* = _size;
            while (_loc_1 < _loc_2)
            {
                
                _loc_1++;
                _loc_3 = _loc_1;
                _loc_4 = _a[_loc_3];
                if (!Std.is(_loc_4, Comparable))
                {
                    Boot.lastError = new Error();
                    throw new AssertionError("element is not of type Comparable", {fileName:"DA.hx", lineNumber:946, className:"de.polygonal.ds.DA", methodName:"_insertionSortComparable"});
                }
                _loc_5 = _loc_3;
                while (_loc_5 > 0)
                {
                    
                    _loc_6 = _a[(_loc_5 - 1)];
                    if (!Std.is(_loc_6, Comparable))
                    {
                        Boot.lastError = new Error();
                        throw new AssertionError("element is not of type Comparable", {fileName:"DA.hx", lineNumber:955, className:"de.polygonal.ds.DA", methodName:"_insertionSortComparable"});
                    }
                    if (_loc_6.compare(_loc_4) > 0)
                    {
                        _a[_loc_5] = _loc_6;
                        _loc_5--;
                        continue;
                    }
                    break;
                }
                _a[_loc_5] = _loc_4;
            }
            return;
        }// end function

        public function _insertionSort(param1:Function) : void
        {
            var _loc_4:int = 0;
            var _loc_5:* = null as Object;
            var _loc_6:int = 0;
            var _loc_7:* = null as Object;
            var _loc_2:int = 1;
            var _loc_3:* = _size;
            while (_loc_2 < _loc_3)
            {
                
                _loc_2++;
                _loc_4 = _loc_2;
                _loc_5 = _a[_loc_4];
                _loc_6 = _loc_4;
                while (_loc_6 > 0)
                {
                    
                    _loc_7 = _a[(_loc_6 - 1)];
                    if (this.param1(_loc_7, _loc_5) > 0)
                    {
                        _a[_loc_6] = _loc_7;
                        _loc_6--;
                        continue;
                    }
                    break;
                }
                _a[_loc_6] = _loc_5;
            }
            return;
        }// end function

        public function __set(param1:int, param2:Object) : void
        {
            _a[param1] = param2;
            return;
        }// end function

        public function __get(param1:int) : Object
        {
            return _a[param1];
        }// end function

        public function __cpy(param1:int, param2:int) : void
        {
            _a[param1] = _a[param2];
            return;
        }// end function

    }
}
