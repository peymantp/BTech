var OTP = require("./OTP.js");


var encryptDecrypt = function(phrase, key){
    var encrypted = OTP.encrypt(phrase, key)
    var decrypted = OTP.decrypt(encrypted, key)
	console.log({ phrase, key, encrypted, decrypted})
	console.log("\n")
}

var key = "MUOZDMPRMIMDFVDEUDQDDJIKBHVIKDVXWDFUQTGV";
var keyWithNumbers = "MUOZDM12345DFRDEUDQDDJIKB98632XWDFUBTGV"
var KeySmall = "ABAACADA"
var phrase = "This is a secret message: hello, world!"
var phraseWithNumbers = "Our job is to get from 40% bad to 0% bad in 29 months"
var phraseAlphanum = "a782ghuy984bn12f87665czasfg220f129dhkh"
encryptDecrypt(phrase, key)
encryptDecrypt(phrase, keyWithNumbers)
encryptDecrypt(phraseWithNumbers, key)
encryptDecrypt(phraseWithNumbers, keyWithNumbers)
encryptDecrypt(phraseAlphanum, key)
encryptDecrypt(phraseAlphanum, keyWithNumbers)
encryptDecrypt(phraseWithNumbers, KeySmall)
var decryptedMessage = OTP.decrypt("TZLSAVATECRETMESSAGE:HELLO,WORLD!", key);
console.log(decryptedMessage);




