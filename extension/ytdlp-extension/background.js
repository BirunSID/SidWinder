// Listen for when you click the extension's toolbar icon
chrome.action.onClicked.addListener((tab) => {
  if (tab.url) {
    // Send the URL to our local native messaging host
    chrome.runtime.sendNativeMessage(
      'com.foss.ytdlp',
      { url: tab.url }
    );
  }
});