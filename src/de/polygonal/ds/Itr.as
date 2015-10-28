package de.polygonal.ds
{

    public interface Itr
    {

        public function Itr() : void;

        function reset() : void;

        function next() : Object;

        function hasNext() : Boolean;

    }
}
