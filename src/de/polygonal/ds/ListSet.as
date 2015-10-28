package de.polygonal.ds
{
    import de.polygonal.core.fmt.*;
    import de.polygonal.core.util.*;
    import de.polygonal.ds.*;
    import flash.*;

    public class ListSet extends Object implements Set
    {
        public var _a:DA;

        public function ListSet() : void
        {
            if (Boot.skip_constructor)
            {
                return;
            }
            _a = new DA();
            return;
        }// end function

        public function toString() : String
        {
            var _loc_4:int = 0;
            var _loc_5:* = null as DA;
            var _loc_1:* = Sprintf.format("\n{ListSet, size: %d}", [size()]);
            if (size() == 0)
            {
                return _loc_1;
            }
            _loc_1 = _loc_1 + "\n|<\n";
            var _loc_2:int = 0;
            var _loc_3:* = size();
            while (_loc_2 < _loc_3)
            {
                
                _loc_2++;
                _loc_4 = _loc_2;
                _loc_5 = _a;
                if (_loc_4 >= 0)
                {
                }
                if (_loc_4 >= _loc_5._size)
                {
                    Boot.lastError = new Error();
                    throw new AssertionError(Sprintf.format("the index %d is out of range %d", [_loc_4, (_loc_5._size - 1)]), {fileName:"DA.hx", lineNumber:144, className:"de.polygonal.ds.DA", methodName:"get"});
                }
                _loc_1 = _loc_1 + Sprintf.format("  %s\n", [Std.string(_loc_5._a[_loc_4])]);
            }
            _loc_1 = _loc_1 + ">|";
            return _loc_1;
        }// end function

        public function toDA() : DA
        {
            return _a.toDA();
        }// end function

        public function toArray() : Array
        {
            return _a.toArray();
        }// end function

        public function size() : int
        {
            return _a._size;
        }// end function

        public function set(param1:Object) : Boolean
        {
            var _loc_2:* = null as DA;
            var _loc_4:int = 0;
            var _loc_6:int = 0;
            _loc_2 = _a;
            var _loc_3:Boolean = false;
            _loc_4 = 0;
            var _loc_5:* = _loc_2._size;
            while (_loc_4 < _loc_5)
            {
                
                _loc_4++;
                _loc_6 = _loc_4;
                if (_loc_2._a[_loc_6] == param1)
                {
                    _loc_3 = true;
                    break;
                }
            }
            if (_loc_3)
            {
                return false;
            }
            else
            {
                _loc_2 = _a;
                _loc_4 = _loc_2._size;
                if (_loc_4 >= 0)
                {
                }
                if (_loc_4 > _loc_2._size)
                {
                    Boot.lastError = new Error();
                    throw new AssertionError(Sprintf.format("the index %d is out of range %d", [_loc_4, _loc_2._size]), {fileName:"DA.hx", lineNumber:157, className:"de.polygonal.ds.DA", methodName:"set"});
                }
                if (_loc_4 >= _loc_2._maxSize)
                {
                    Boot.lastError = new Error();
                    throw new AssertionError(Sprintf.format("size equals max size (%d)", [_loc_2._maxSize]), {fileName:"DA.hx", lineNumber:158, className:"de.polygonal.ds.DA", methodName:"set"});
                }
            }
            _loc_2._a[_loc_4] = param1;
            if (_loc_4 >= _loc_2._size)
            {
                (_loc_2._size + 1);
            }
            return true;
        }// end function

        public function remove(param1:Object) : Boolean
        {
            return _a.remove(param1);
        }// end function

        public function merge(param1:Set, param2:Boolean, param3:Object = ) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null as Object;
            if (param2)
            {
                _loc_4 = param1.iterator();
                
                if (_loc_4.hasNext())
                {
                    _loc_5 = _loc_4.next();
                    set(_loc_5);
                    ;
                }
            }
            else if (param3 != null)
            {
                _loc_4 = param1.iterator();
                
                if (_loc_4.hasNext())
                {
                    _loc_5 = _loc_4.next();
                    set(this.param3(_loc_5));
                    ;
                }
            }
            else
            {
                _loc_4 = param1.iterator();
                
                if (_loc_4.hasNext())
                {
                    _loc_5 = _loc_4.next();
                    if (!Std.is(_loc_5, Cloneable))
                    {
                        Boot.lastError = new Error();
                        throw new AssertionError(Sprintf.format("element is not of type Cloneable (%s)", [_loc_5]), {fileName:"ListSet.hx", lineNumber:129, className:"de.polygonal.ds.ListSet", methodName:"merge"});
                    }
                    set(_loc_5.clone());
                    ;
                }
            }
            return;
        }// end function

        public function iterator() : Itr
        {
            return _a.iterator();
        }// end function

        public function isEmpty() : Boolean
        {
            return _a._size == 0;
        }// end function

        public function has(param1:Object) : Boolean
        {
            var _loc_6:int = 0;
            var _loc_2:* = _a;
            var _loc_3:Boolean = false;
            var _loc_4:int = 0;
            var _loc_5:* = _loc_2._size;
            while (_loc_4 < _loc_5)
            {
                
                _loc_4++;
                _loc_6 = _loc_4;
                if (_loc_2._a[_loc_6] == param1)
                {
                    _loc_3 = true;
                    break;
                }
            }
            return _loc_3;
        }// end function

        public function free() : void
        {
            _a.free();
            _a = null;
            return;
        }// end function

        public function contains(param1:Object) : Boolean
        {
            var _loc_6:int = 0;
            var _loc_2:* = _a;
            var _loc_3:Boolean = false;
            var _loc_4:int = 0;
            var _loc_5:* = _loc_2._size;
            while (_loc_4 < _loc_5)
            {
                
                _loc_4++;
                _loc_6 = _loc_4;
                if (_loc_2._a[_loc_6] == param1)
                {
                    _loc_3 = true;
                    break;
                }
            }
            return _loc_3;
        }// end function

        public function clone(param1:Boolean, param2:Object = ) : Collection
        {
            var _loc_3:* = Type.createEmptyInstance(ListSet);
            _loc_3._a = _a.clone(param1, param2);
            return _loc_3;
        }// end function

        public function clear(param1:Boolean = false) : void
        {
            var _loc_3:* = null as Object;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_2:* = _a;
            if (param1)
            {
                _loc_3 = null;
                _loc_4 = 0;
                _loc_5 = _loc_2._a.length;
                while (_loc_4 < _loc_5)
                {
                    
                    _loc_4++;
                    _loc_6 = _loc_4;
                    _loc_2._a[_loc_6] = _loc_3;
                }
            }
            _loc_2._size = 0;
            return;
        }// end function

    }
}
