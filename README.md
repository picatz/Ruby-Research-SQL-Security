# IA 480 

Class work for an SQL Security class where we are asked to build up our own applications in PHP. I've been allowed to use Ruby, thankfully! So, I'll be storing all of the code required for class on here as a backup and as reference for myself / other rubyists to learn some fun things by writing some purposely bad things. Ruby research! 

---

## Login Page

Generated a silly login page with [Boostrap](http://getbootstrap.com/) and [Validator](http://1000hz.github.io/bootstrap-validator/) along with a little bit of custom javascript to determine if the username and password match the hardcoded values on the page.

#### Security Note

This login page is obviously a bit of a joke. But, it looks good. :)

---

## MySQL Database and Table

### info_mysql_server.rb

A simple application I wrote to get basic information about the local mysql server I am using: `ruby info_mysql_server.rb`

### make_db_and_table_assigment.rb

The main application to complete the assignment. Creates the required database, table and the required information for the assignment.

#### Security Note

Why no password for the mysql server? Leaving it extra insecure as I build up my examples for class, as I'm going to have to harden the application. I may even end up dropping mysql all together in favor of something like postgresql. Also running these examples in a VM without internet access / and even proper firewall rules setup for fun. So, I'm fairly complicated I won't have to worry about my mysql server being pwnd by the 1337 haxorz. lol 

---
