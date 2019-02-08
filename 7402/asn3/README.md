# one-time-pad

a simple one-time pad cipher written in nodejs

### rules for this library

* The key and message must only contain alphabetical letters.
* All spaces in message and key will be removed when generating an encrypted message.
* Punctuation and numbers will not be encrypted (in the future it will)

### usage

```
var pad = require("one-time-pad");
var encryptedMessage = pad.encrypt("SECRET MESSAGE", "ZXYSMMVBSTTVJ");
console.log(encryptedMessage); // RBAJQFHFKLTBN

var decryptedMessage = pad.decrypt("RBAJQFHFKLTBN", "ZXYSMMVBSTTVJ");
console.log(decryptedMessage); // SECRETMESSAGE
```

LICENSE: MIT