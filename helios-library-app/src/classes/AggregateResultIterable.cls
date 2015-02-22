public class AggregateResultIterable implements Iterable<AggregateResult> {
    String query {get; set;}
    
    public AggregateResultIterable(String query) {
        this.query = query;
    }
    
    public Iterator<AggregateResult> iterator() {
        return new AggregateResultIterator(query);
    }
}