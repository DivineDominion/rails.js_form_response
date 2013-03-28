Fixing JangoSteve's rails.js form callback example
==================================================
 
I struggled with Ruby on Rails Unobstrusive JavaScript (UJS) handling form responses.  When form validation failed, the JavaScript in the response body simply wasn't executed.  Ever.

Steve Schwartz aka JangoSteve clearly instructed us how Rails' UJS driver behaves.  Only not even his example doesn't work out of the box.

Think of this as a working example made from his code samples.

Scenario or Expected User Story gone wrong
------------------------------------------

Here's what happens out of the box:

1.  Submit form with `:remote => true` enabled,
2.  validate user input.
    *   For valid user input,
        1.  render `create.js.erb` with jQuery instructions to insert the object's content into the page DOM, and
        2.  pass a HTTP status code of 201 Created along.
        3.  Expect jQuery to execute the JavaScript code the server prepared as HTTP response body.
    *   For invalid user input,
        1.  render `create.js.erb` with jQuery instructions to build error messages, and
        2.  pass a HTTP status code of 400 Bad Request or 424 Unprocessable Entity because it's the right thing to do, as you know very well.
        3.  <del>Here, too, expect jQuery to execute the JavaScript code the server prepared as HTTP response body.</del> <ins>Be disappointed because the response body is right but nothing is executed for mysterious reasons.</ins>
        4.  <del>Change the HTTP response status code to 200 or something similar just to satisfy jQuery and have the JavaScript code executed automatically.</del> -- Please, don't.
3.  Continue using the web app/web service, whatever.

Fixing the problem
------------------

Giving up the HTTP 4xx status codes isn't an option.  We really shouldn't give in to <del>terrorists</del> <ins>`rails.js` internal quirks</ins>.

As [JangoSteve clearly instructed us,][2] the current jQuery UJS driver supports the following four event callbacks:

    ajax:beforeSend
    ajax:success
    ajax:complete
    ajax:error

Turns out HTTP response 400 triggers `ajax:error` instead of `ajax:success`.  `ajax:success` results in the XMLHttpRequest's (XHR) response body's execution (or rather: `eval`uation.) while `ajax:error` doesn't.

Not-so-Quickfix:  `eval` XHR's response on `ajax:error` callbacks.

    // put this in app/assets/javascripts/application.js for example
    $(document).ready(function() {
      $('form[data-remote="true"]').bind('ajax:error', function(evt, xhr, status){
        eval(xhr.responseText);
      });
    });

Works.

  [1]: http://www.alfajango.com/blog/rails-3-remote-links-and-forms-data-type-with-jquery/comment-page-1/#comment-4611
  [2]: http://www.alfajango.com/blog/rails-3-remote-links-and-forms/
