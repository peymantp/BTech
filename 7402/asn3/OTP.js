'use strict';
var fs = require('fs');
/**
 * @author Peyman Tehrani Parsa
 * @class OTP
 * @summary Implementation of one time pad cipher
 */
class OTP {
    constructor(file ='', key = '', cypher = '') {
        if (file != '') {
            this.msg = this.readFile(file);
        }
        if (key == '') {
            this.key = this.generateKey(this.msg.length);
            this.key = this.stringToBinary(this.key);
        } else {
            this.key = this.stringToBinary(key);
        }
        if (cypher == '') {
            this.cypher = '';
        } else {
            this.cypher = this.stringToBinary(cypher);
        }
    }

    /**
     *	Generate Secret Key
     *
     *	@param {number} txtlength	key length based on msg length
     *	@return				Secret key
     */
    generateKey(txtlength) {
        var key = '';

        //-- Generate secret key with same length as message --
        for (var i = 0; i < txtlength; i++)
            key += String.fromCharCode(Math.floor(0x0020 + Math.random() * (0x007E-0x0020+1)));

        return key;
    }
    /**
     * 
     * @param {String} file text file that'll be read into memory
     */
    readFile(file) {
        /**
         *	Cleanse Text
         *
         *	@param {number}txt			Text to cleanse
         *	@return				Cleansed text
         */
        function cleanseText(txt) {
            //-- If no message, warn user --
            txt = txt.toUpperCase();
            return txt.replace(/xxx[\x00-\x7F]+xxx/gi, '');
        }
        try {
            return (fs.readFileSync(file, 'utf8'));
        } catch (error) {
            console.error('Error:', error.stack);
        }
    }
    /**
     * @param {string} str Text that'll be converted to binary string
     * @param {boolean} spaceSeparated Default: False, set to true for pretty print
     * @returns Binary string of msg
     */
    stringToBinary(str, spaceSeparated = false) {
        function zeroPad(num) {
            return "00000000".slice(String(num).length) + num;
        }

        return str.replace(/[\s\S]/g, function (str) {
            str = zeroPad(str.charCodeAt().toString(2));
            return str
        });
    }

    binaryToString(text) {
        text = text.match(/.{8}/g).join(" ");
        var newBinary = text.split(" ");
        var binaryCode = [];

        for (var i = 0; i < newBinary.length; i++) {
            binaryCode.push(String.fromCharCode(parseInt(newBinary[i], 2)));
        }

        return binaryCode.join('');
    }

    encrypt() {
        var msg = this.stringToBinary(this.msg);
        var cypher = '';
        for (let i = 0; i < msg.length; i++) {
            cypher += (msg[i] ^ this.key[i]).toString(2);
        }
        this.cypher = cypher;
    }

    getCypher(){
        return this.binaryToString(this.cypher);
    }

    getKey(){
        return this.binaryToString(this.key);
    }
    decrypt() {
        
        var plain = '';
        for (let i = 0; i < this.cypher.length; i++) {
            plain += (this.cypher[i] ^ this.key[i]).toString(2);
        }
        return this.binaryToString(plain);
    }
};

module.exports = OTP;