public class AggregateResultIterator implements Iterator<AggregateResult> {
    AggregateResult[] results {get; set;}
    Integer nextIndex {get; set;}
    
    public AggregateResultIterator(String query) {
        nextIndex = 0;
        results = Database.query(query);
    }
    
    public boolean hasNext() {
        return nextIndex < results.size();
    }
    
    public AggregateResult next() {
        return results[nextIndex++];
    }
    
}