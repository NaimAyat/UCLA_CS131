import java.util.concurrent.atomic.AtomicIntegerArray;

class GetNSetState implements State {
    private byte maxval;
    private AtomicIntegerArray atomArr;

    // Convert bytes in array to ints
    public static int[] convert(byte[] arr) {
        int[] curr = new int[arr.length];
        int i = 0;
        while (i < arr.length) {
            curr[i] = (int) arr[i];
            i++;
        }
        return curr;
    }

    GetNSetState(byte[] v) { 
        atomArr = new AtomicIntegerArray(this.convert(v));
        maxval = 127; 
    }

    GetNSetState(byte[] v, byte m) { 
    	maxval = m;
        atomArr = new AtomicIntegerArray(this.convert(v)); 
    }

    public int size() { return atomArr.length(); }

    public byte[] current() {
        int len = atomArr.length();
        byte[] curr = new byte[len];
        int i = 0;
        while (i < len) {
            curr[i] = (byte) atomArr.get(i);
            i++;
        }
        return curr;
    }

    public boolean swap(int i, int j) {
        if (atomArr.get(i) <= 0 || atomArr.get(j) >= maxval) {
            return false;
        }
        atomArr.getAndDecrement(i);
        atomArr.getAndIncrement(j);
        return true;
    }
}
