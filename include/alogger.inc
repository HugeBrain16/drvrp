/*
*   File Name: alogger.inc
*   Author = https://github.com/BagusPrasetyo373/
*   Description = A simple and easy-to-use logger for SA:MP
*   Date = 1/10/2021
*   Last Update = 1/10/2021
*/

/*
MIT License

Copyright (c) 2021 Bagus Prasetyo

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

#include <a_samp> /* samp-stdlib */
#include <regex> /* https://github.com/GRGServer/SAMP/blob/master/includes/regex.inc i found this plugin on this repo */

#if defined alogger_inc
	#endinput
#endif
#define alogger_inc

#define ALOGGER_MAX_STR 1000
#define ALOGGER_VERSION "1.0.1"

stock ValidLogFile(file[])
{
    new File:FH;
    FH = fopen(file,io_read);
    if(FH) {
        fclose(FH);
        if(regex_match("^[a-zA-Z0-9]+[.]+log$",file)) return 0;
        return 1;
    }
    return 0;
}

stock LogFileExists(file[])
{
    new File:FH;
    
    if(!ValidLogFile(file)) return 0;
    FH = fopen(file,io_read);
    if(FH) {
        fclose(FH);
        return 1;
    }
    return 0;
}

stock Logger(file[], text[])
{
	new
		checkf[ALOGGER_MAX_STR],
        time[6],
		File:FH;
    gettime(time[0],time[1],time[2]);
    getdate(time[3],time[4],time[5]);
	if(!ValidLogFile(file)) return 0;
	FH = fopen(file, io_append);
	if(FH) {
        /* If no carriage return '\r' and new line '\n' at the end of the string */
		if(regex_match(".+\r\n",text)) {
			format(checkf,sizeof(checkf),"(%d/%02d/%02d)[%02d:%02d:%02d]: %s\r\n",
                time[5],
                time[4],
                time[3],
                time[0],
                time[1],
                time[2],
                
                text
            );
			fwrite(FH, checkf);
		}
		else {
            format(checkf,sizeof(checkf),"(%d/%02d/%02d)[%02d:%02d:%02d]: %s",
                time[5],
                time[4],
                time[3],
                time[0],
                time[1],
                time[2],
                
                text
            );
            fwrite(FH, checkf);
		}
        fclose(FH);
		return 1;
	}
	return 0;
}

/* Haven't test this yet... */
stock FlushLogger(file[])
{
	new
		buffer[ALOGGER_MAX_STR],
		File:FH;
	FH = fopen(file);
	if(FH) {
		while(fread(FH,buffer)) {
			fwrite(FH,"\b\r\n");
		}
		fclose(FH);
		return 1;
	}
	return 0;
}

stock RemoveLogger(file[])
{
    if(!LogFileExists(file)) return 0;
    fremove(file);
    return 1;
}

stock CreateLogFile(file[])
{
	new File:FH;
	
	if(LogFileExists(file)) return 0;
	if(!ValidLogFile(file)) return 0;
	
	FH = fopen(file,io_write);
	if(FH) {
		fclose(FH);
		return 1;
	}
	return 0;
}