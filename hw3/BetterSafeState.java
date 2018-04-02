import java.util.concurrent.locks.ReentrantLock;

class BetterSafeState implements State{
    private byte[] value;
    private byte maxval;
    private ReentrantLock myLock;
    
    BetterSafeState(byte[] v) { 
        maxval = 127;
        value = v; 
        myLock= new ReentrantLock();
    }
	
    BetterSafeState(byte[] v, byte m) { 
        maxval = m; 
        value = v;
        myLock= new ReentrantLock();
    }

    public int size() { return value.length; }

    public byte[] current() { return value; }

    public boolean swap(int i, int j) {
        myLock.lock();
        if (value[i] <= 0 || value[j] >= maxval) {
            myLock.unlock();
            return false;
        }
        value[i]--;        
        value[j]++;
        myLock.unlock();
        return true;
    }
}
