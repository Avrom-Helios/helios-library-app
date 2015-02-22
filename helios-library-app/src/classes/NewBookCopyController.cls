public class NewBookCopyController {
  public Book_copy__c newCopy {public get; public set;}
  
  public NewBookCopyController() {
     newCopy = new Book_Copy__c();
     newCopy.book__c = ApexPages.currentPage().getParameters().get('bookId');
     newCopy.book__r = [SELECT id, title__c, Author_Display_Name__c from book__c where id = :newCopy.book__c];
  }
  
  public PageReference save() {
      insert newCopy;
      return returnToBook();
  }
  
  public PageReference cancel() {
      return returnToBook();
  }
  
  private PageReference returnToBook() {
      PageReference bookret = Page.Book;
      bookret.getParameters().put('id', newCopy.book__c);
      return bookret;
  }
}