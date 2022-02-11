#!/bin/sh 
#1190707-Lojain Abdalrazaq
#1190587-Aseel Deek
# ------------------------------------------ Read File-------------------------------------------
readFile() {
while true 
do
# read from the user and check if the file exists or not 
read -p "Enter here the File Name (filename.txt): " file 

file="$(echo "$file" | sed 's/.*/\u&/')" # captialize the filename 

if [ ! -e "$file" ] # 1st if checks if the file exisits or not 
then
   echo "the file [$file], does not exist, would you like to enter another file name (1) / or to stop (0) "
   read answer
   if [ "$answer" -eq  1  ]  # 2ed if ( check if the user want to continue opening the file ot not )
   then 
    continue
   else
    exit 1
   fi # end of the 2ed if  
else  
   echo "the file [$file], exists! \n"
   break
fi   #  end of the 1st if  

done # end of while loop 

}
#---------------------------------------------- Search Function --------------------------------------

# this function asks for string to search for 
SearchFunction() { 
read -p "Enter the string you are looking for: " str
at=@ #variable 
str=$(echo "$str" | sed  's/ /, /g' ) # this case for entering "aseel deek"  < removes the space and repalce it by ,space 
if  (  echo "$str" | grep -q "$at"  ) # this case to prvent changing the mail address to upper case   
then 
   if grep -q "$str" "$file"; then
    echo "$str was found\n"
   else
   echo  "$str was not found1\n"  
   fi 
                          
elif ! (  echo "$str" | grep -q "$at"  )  # this case is the oposite 
then   
   str=$( echo "$str" | sed -r 's/\<./\U&/g' )  # convert the firsr letter  in each word to upper 
   if grep -q "$str" "$file"; then # if these words exist, then print the found message 
     echo "$str was found\n"
   else
   echo  "$str was not found3\n"  
   fi               
fi 

}
#--------------------> EditFunction <-----------

EditFunction(){
echo "\n"
echo "************************************************************"
echo "\n"
echo "\tHello, Here is the content of "$file":"
echo "\n"
cat -n "$file"
echo "\n"
echo "************************************************************"

#Calculate the number of cantacts in the txt file
num=$(cat -n "$file" | wc -l)
#
read -p "Please Enter the Number of the line to edit in it : " LineNumber

#while loop will continue until the user enter a valid line number
while [ "$LineNumber" -gt "$num" ]
do
#Error message when the user enter invlid line number to edit in it
read -p "Invalid Number, Please Enter Again: " LineNumber
done

#Dispalying the line that the user has chose
sed -n "$LineNumber p" "$file"

#*************
read -p "Enter the value to edit: " str
at=@

#checking the data is found or not
#-------------------FOUND-----------------
if  sed -n "$LineNumber p" "$file" | grep -q "$str" ; then

  echo "[ $str ] is found...." 

#*****************NAMES******************

  # if statment check if the entered data is name [only chars]
  if ! [ -z "${str##*[^a-zA-Z]*}" ] ; then
  #prints ints a string value
  read -p "Enter the edited (new) value: " editStr
  #while loop to check if the edited value is only chars
  while [ -z "${editStr##*[^a-zA-Z]*}" ]
  do
  #keeps until the input (edited value is VALID -->only chars)
  read -p "Enter the edited value only (chars): " editStr
  done
  #get out the loop when its valid
  #saving the data in the file 
  sed -e 's/'$str'/'$editStr'/g' "$file" < "$file" > temp1.txt
  cp "temp1.txt" "$file"
  echo "The data is edited succefully."
  
 #-------------------------------------------------------------------------------
 
 #***************PHONE NUMBERS******************

  #if the input is number
  elif ! [ -z "${str##*[!0-9]*}" ] ; then
  read -p "Enter the edited (new) value: " editNum
  #while loop will keep until the value of the edited number is VALID --> only numbers
  while [ \( "${#editNum}" -ne 10 \) -a \( "${#editNum}" -ne 9 \) -o \( -z "${editNum##*[!0-9]*}" \) ]
  do
  read -p "Enter the the edited value (only number) & at least 9 numbers and 10 at most: " editNum
  done
  #get out the loop when its valid
  #saving the data in the file 
   sed -e 's/'$str'/'$editNum'/g' "$file" < "$file" > temp1.txt
  cp "temp1.txt" "$file"
  echo "the data is edited"
  #------------------------------------------------------------------------------
  #*****************EMAIL************************
 
  else
  #if the value was not name (only chars) or number
  #then it will be an email (cantains a combination of number, strings and chars like '@', '.' )
  read -p "Enter the edited (new) value: " editEmail
  #while loop will keep until the input value contains (@) sign
  while ! ( echo "$editEmail" | grep -q "$at" )
  do 
  read -p "Enter the edited value (must have @ sign):" editEmail
  done
  #get out the loop when its valid
  #saving the data in the temp.txt file 
  sed -e 's/'$str'/'$editEmail'/g' "$file" < "$file" > temp1.txt
  cp "temp1.txt" "$file"
  echo "the data is edited"
  
  fi 
#****************NO MATCH********************
#   --------------------NOT FOUND-----------------
# if the input data is not found in the file
else 
  #printing an error message that its not found
  echo " [ $str ]  is NOT found\n"  
fi 

}

# -----------------------------------------Delete Function --------------------------------------------

# the idea od this function is to list the whole contant and according to the line number, delete the data 
DeleteFunction() {
cat -n "$file"     # list the file contant 
num=$( cat -n "$file" |  wc -l ) # find the number of lines in the file 
printf "\n" # space 
read -p "Enter the Line Number you want to Remove: " n
while [ \( "$n" -gt "$num" \) ]  # this case handel when the entered value is not a line number 
do 
 read -p "Please Only the Given line numbers ! : " n
done 
 sed -i ''$n'd' $file  
 echo "\nLine $n has been deleted \n"  # delete the specified line number 
}

#------------------------------------------Add Function----------------------------

# this function add new data to the contacts file, each data is restricted  according to project requirments
AddFunction() {
read -p "Enter the First Name:" first
#  checks if the entered value is characters  or not 
while [ -z "${first##*[^a-zA-Z]*}" ]  # force thr user to enter a value for this field
do 
   echo "Plase, enter the first name!"
   read -p "Enter the First Name:" first   
done 
#---------------
read -p "Enter the Last Name:" last
# checks if the entered value is characters  or not 
while [ "$last" != "" -a -z "${last##*[^a-zA-Z]*}"  ]  #  first part of the and operater to not force the user to enter the last name 
do 
   echo "Plase name as characters!"
   read -p "Enter the Last Name:" last 
done
#---------------
read -p "Enter the Phone numbers:" numbers
# checks 4 cases if the enter nothing --> error, less than 9 more than 10 also error, and whhen the value isn't integer
while [ \( "${#numbers}" -ne 10 \)  -a \( "${#numbers}" -ne 9 \) -o  \( -z "${numbers##*[!0-9]*}" \)  ] 
do 
   echo "Plase Just 9 or 10 numbers !"
   read -p "Enter the Phone numbers:" numbers
done
#----------------
read -p "Enter the Email address:" email 
n2=@ # this variable to force the user to enter @ with the email 

while ! ( echo "$email" | grep -q "$n2") # checks the substring form the string 
do
  echo "Invalid! add the @ symbol to make it valid"
  read -p "Enter the Email address:" email 
done

echo "$first, $last, $numbers, $email" >> $file #append  the new data to  the needed file 

}
#----------------------------------------- List Function ----------------------------

ListFunction(){

#The user supposed to enter the choice in order to list the contacts
echo "Hi, Based ON what you want to list the Contacts Information? Press (F) fot the first name ,(L) for the last name / Both( B )?"
#L-->List Name, F-->First Name, B-->Both Colums(Last &First)

read ListChoice
#reading the input from the user
#If the input was non of the option
#the user will be asked to enter a valid choice for listing the contacts

 while [ "$ListChoice" != "L" -a "$ListChoice" != "F" -a "$ListChoice" != "B" -a "$ListChoice" != "l" -a "$ListChoice" != "f" -a "$ListChoice" != "b" ]
 
do
#while loop will keep working until the user enter a valid option

read -p "Bad choice, Please Enter a Valid choice: [F/L/B]: " ListChoice
done

#--------------------------LAST NAME-----------------------
#Last name
# Listing based on the last Name

if [ "$ListChoice" = "L" -o "$ListChoice" = "l" ]
then 

  echo "Last"
  echo "-------"
  #the sed command for removing the comma between the elements
  sed -e 's/,/\t/g' "$file" | cut -d' ' -f2
  
#--------------------------FIRST NAME-----------------------
#First Name 
# Listing based on the first Name
elif [ "$ListChoice" = "F" -o "$ListChoice" = "f" ]
then 
  echo "First"
  echo "-------"
  sed -e 's/,/\t/g' "$file" | cut -d' ' -f1
   
#-------------------------BOTH COLUMS----------------------
#Both columns (First Name & Last Name)
elif [ "$ListChoice" = "B" -o "$ListChoice" = "b" ] 
then 
echo "First  Last"
echo "---------------"
sed -e 's/,/\t/g' "$file" | cut -d' ' -f1,2 

fi
}
# ---------------------------------------Main Function ------------------------------------------------

readFile # calling the function 
while true  
     do 
     # the menu will pop up everytime after an operation done 
      echo " ** Welcome to Contact Management System ****\n\n "
      echo "\t\t MAIN MENU " 
      echo "\t======================" 
      echo "\t[1] Add a new Contact"
      echo "\t[2] List all Contacts"
      echo "\t[3] Search for Contact"
      echo "\t[4] Edit a Contact"
      echo "\t[5] Delete a Contact"
      echo "\t[0] Exit"
      echo "\t=================="
      read -p "        Enter the choice:" choice   # end of the  menu list 
      printf "\n" #space 
   
      
      case "$choice"
         in 
         
         0) echo "-----> Out of Contact Management System\n"  # print this message when exiting the program 
            exit 1;;  # exist the system 
         1) AddFunction;;     # calling the Add function
         2) ListFunction;;    # calling the List function
         3) SearchFunction ;; # calling the Search function  
         4) EditFunction;;  # calling the Edit function  
         5) DeleteFunction ;; # calling the Delete function 
         *) echo "Bad Argument; Please specify a single digit";;       
      esac  
done
