module rip.color.color;

import std.algorithm;

enum DestionationMode {
    Direct,
    New
}

DestionationMode destMode = DestionationMode.New;

class Color(Type, size_t N) {
protected:
    this() {}
    this(T = Type) (T[] data...) {
        setChannels(data);
    }

    auto getColor(T, Args...)(Args args) {
        if(destMode == DestionationMode.New) {   
            return new T(args[1..$]);

        }
        else {
            args[0].setChannels(args[1..$]);
            return args[0];
        }
    }

    void setChannels(T = Type) (T[] data...) {
        static if(is(T == Type)) {
            this.data = data;
        }
        else {
            for(int i = 0; i < N; i++) {
                this[i] = data[i];
            }
        }
    }

    void opIndexAssign(T = Type)(T value, size_t index) {
        static if(is(T == Type)) {
            data[index] = value;
        }
        else {
            data[index] = cast(Type) clamp(value, Type.min, Type.max);
        }
    }

    Type opIndex(size_t index) const {
        return data[index];
    } 

    auto getTypedByIndex(T = Type)(size_t index) const {
        static if(is(T == Type)) {
            return data[index];
        }
        else {
             return cast(T) data[index];
        }
    }

    Type[N]     data;
}