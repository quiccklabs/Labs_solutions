
/**
* @OnlyCurrentDoc
*
* The above comment directs Apps Script to limit the scope of file
* access for this add-on. It specifies that this add-on will only
* attempt to read or modify the files in which the add-on is used,
* and not all of the user's files. The authorization request message
* presented to users will reflect this limited scope.
*/
/**
* Creates a menu entry in the Google Docs UI when the document is
* opened.
*
*/
function onOpen() {
  var ui = DocumentApp.getUi();
  ui.createMenu('Natural Language Tools')
    .addItem('Mark Sentiment', 'markSentiment')
    .addToUi();
}
/**
* Gets the user-selected text and highlights it based on sentiment
* with green for positive sentiment, red for negative, and yellow
* for neutral.
*
*/
function markSentiment() {
  var POSITIVE_COLOR = '#00ff00';  //  Colors for sentiments
  var NEGATIVE_COLOR = '#ff0000';
  var NEUTRAL_COLOR = '#ffff00';
  var NEGATIVE_CUTOFF = -0.2;   //  Thresholds for sentiments
  var POSITIVE_CUTOFF = 0.2;
  var selection = DocumentApp.getActiveDocument().getSelection();
  if (selection) {
    var string = getSelectedText();
    var sentiment = retrieveSentiment(string);
    //  Select the appropriate color
    var color = NEUTRAL_COLOR;
    if (sentiment <= NEGATIVE_CUTOFF) {
      color = NEGATIVE_COLOR;
    }
    if (sentiment >= POSITIVE_CUTOFF) {
      color = POSITIVE_COLOR;
    }
    //  Highlight the text
    var elements = selection.getSelectedElements();
    for (var i = 0; i < elements.length; i++) {
      if (elements[i].isPartial()) {
        var element = elements[i].getElement().editAsText();
        var startIndex = elements[i].getStartOffset();
        var endIndex = elements[i].getEndOffsetInclusive();
        element.setBackgroundColor(startIndex, endIndex, color);
      } else {
        var element = elements[i].getElement().editAsText();
        foundText = elements[i].getElement().editAsText();
        foundText.setBackgroundColor(color);
      }
    }
  }
}
/**
 * Returns a string with the contents of the selected text.
 * If no text is selected, returns an empty string.
 */
function getSelectedText() {
  var selection = DocumentApp.getActiveDocument().getSelection();
  var string = "";
  if (selection) {
    var elements = selection.getSelectedElements();
    for (var i = 0; i < elements.length; i++) {
      if (elements[i].isPartial()) {
        var element = elements[i].getElement().asText();
        var startIndex = elements[i].getStartOffset();
        var endIndex = elements[i].getEndOffsetInclusive() + 1;
        var text = element.getText().substring(startIndex, endIndex);
        string = string + text;
      } else {
        var element = elements[i].getElement();
        // Only translate elements that can be edited as text; skip
        // images and other non-text elements.
        if (element.editAsText) {
          string = string + element.asText().getText();
        }
      }
    }
  }
  return string;
}
/** Given a string, will call the Natural Language API and retrieve
  * the sentiment of the string.  The sentiment will be a real
  * number in the range -1 to 1, where -1 is highly negative
  * sentiment and 1 is highly positive.
*/
function retrieveSentiment (line) {
//  TODO:  Call the Natural Language API with the line given
//         and return the sentiment value.
  return 0.0;
}




