// assignment_model.dart
class Assignment {
  final String id;
  final String title;
  final String subject;
  final String difficulty;
  final List<String> questions;

  Assignment({
    required this.id,
    required this.title,
    required this.subject,
    required this.difficulty,
    required this.questions,
  });

  String get questionCount => "${questions.length} Questions";
}

// assignments_data.dart
class AssignmentsData {
  static final List<Assignment> allAssignments = [
    Assignment(
      id: "1",
      title: "Getter & Setter",
      subject: "Java Programming Fundamental",
      difficulty: "Beginner",
    
questions: [
  "Create a Person class with the following fields: firstName, lastName, age, gender, address. Write getter and setter methods for each field.",
  "Write a Car class with the fields: make, model, year, color, owner. Write getter and setter methods for each field.",
  "Implement a Book class with fields: title, author, genre, publisher, pageCount. Write getter and setter methods for each.",
  "Create a Student class with fields: name, rollNumber, className, email, phoneNumber. Write getters and setters.",
  "Write a Device class with fields: brand, model, serialNumber, owner, location. Provide getter and setter methods for all fields.",
  "Create a Movie class with fields: title, director, genre, releaseYear, language. Write getter and setter methods for each.",
  "Write a Laptop class with fields: brand, processor, ramSize, storageSize, graphicsCard. Provide getter and setter methods.",
  "Create a Rectangle class with fields: length, width, color, borderThickness, material. Write getter and setter methods for each.",
  "Implement a City class with fields: name, country, state, zipCode, mayor. Provide getter and setter methods for all.",
  "Write an Animal class with fields: name, species, age, habitat, diet. Provide getter and setter methods for each field.",
  "Write an Employee class with fields: employeeId, name, position, department, email. Add getters and setters for all fields.",
  "Create a University class with fields: universityName, location, rank, totalStudents, totalFaculties. Provide getter and setter methods.",
  "Implement a House class with fields: address, numRooms, area, ownerName, type. Write getters and setters for each.",
]
    ),
    Assignment(
      id: "2",
      title: "Input/Scanner",
      subject: "Java Programming Fundamental",
      difficulty: "Beginner",
      questions: [
  "Take a statement as input from user and print its first word.",
  "Take a double as input from user, cast it to int, and print its value.",
  "Take a char as input from user and print its ASCII value.",
  "Take salary of two employees in float and print the average.",
  "Prompt user to enter marks of different subjects and print total marks and percentage.",
  "Prompt user to enter name, father name, age, occupation, goal, aspirations and print a 'My Self' paragraph.",
     "Take a string as input and print the length of its first word.",
    "Take age from user, convert it into seconds, and print the result.",
     "Take a long as input and print it using a single statement (anonymous approach).",
     "Create a Student class with name, roll number, fees, student count, all constructors, getters/setters, discount methods, average/percentage methods, and a print method.",
        ]
    ),
    Assignment(
      id: "3",
      title: "Operators",
      subject: "Java Programming Fundamentals",
      difficulty: "Beginner",
      questions: [
  "What will be the value of result and i after the operation: int i = 7; int result = i++ + ++i + i++;",
  "Determine the values of a and b: int a = 10; int b = a++ * 2 + --a;",
  "Determine the values of m, n, and o: int m = 2, n = 3; int o = (m++ * --n) + (++m * n--);",
  "Predict the output of the following operation: int a = 1, b = 2, c = 3; int result = a++ + b * ++c - --a; System.out.println(result); System.out.println(a); System.out.println(b); System.out.println(c);",
  "Determine the values of x, y, and result: int x = 2, y = 3; int result = x++ * --y + y++ / ++x - x--;",
  "Calculate the final values of a, b, c, and result: int a = 2, b = 4, c = 5; int result = (a++ / ++c) * (++a * --b) + (c++ - ++b / --a);",
]
    ),

    Assignment(
      id: "4",
      title: "Number System",
      subject: "Programming Fundamental",
      difficulty: "Beginner",
questions: [
  "Convert (10101101101)₂ to hexadecimal.",
  "Convert (3F9)₁₆ to binary.",
  "Convert (725)₈ to binary.",
  "Convert (1101011101)₂ to octal.",
  "Convert (B9F)₁₆ to decimal.",
  "Convert (457)₈ to hexadecimal.",
  "Convert (1011011110)₂ to decimal.",
  "Convert (987)₁₀ to binary.",
  "Convert (5D3)₁₆ to octal.",
  "Convert (110101011001)₂ to hexadecimal.",
  "Convert (7F2)₁₆ to binary.",
  "Convert (562)₈ to binary.",
  "Convert (1011011001)₂ to octal.",
  "Convert (2AE)₁₆ to decimal.",
  "Convert (634)₈ to hexadecimal.",
  "Convert (1001111001)₂ to decimal.",
  "Convert (1456)₁₀ to binary.",
  "Convert (2F8)₁₆ to octal.",
  "Convert (111001011110)₂ to hexadecimal.",
  "Convert (3DB)₁₆ to binary.",
  "Convert (111010111101)₂ to hexadecimal.",
  "Convert (6F4)₁₆ to binary.",
  "Convert (753)₈ to binary.",
  "Convert (11011011101)₂ to octal.",
  "Convert (CAF)₁₆ to decimal.",
  "Convert (527)₈ to hexadecimal.",
  "Convert (10111001101)₂ to decimal.",
  "Convert (1842)₁₀ to binary.",
  "Convert (7AC)₁₆ to octal.",
  "Convert (110011010111)₂ to hexadecimal.",
]
    ),

    Assignment(
      id: "7",
      title: "if-else Statement",
      subject: "Programming Fundamentals",
      difficulty: "Beginner",
      questions: [
  "Write a Java program to accept two integers and check whether they are equal or not?",
  "Write a Java program to check whether a given number is even or odd?",
  "Write a Java program to read the age of a candidate and determine whether it is eligible for casting his/her own vote?",
  "Write a Java program to find whether a given year is a leap year or not?",
  "Write a Java program to read the value of an integer m and display the value of n is 1 when m is larger than 0, 0 when m is 0 and -1 when m is less than 0?",
  "Write a Java program to accept the height of a person in centimeter and categorize the person according to their height?",
  "Write a java program take values of length and breadth of a rectangle from user and check if it is square or not?",
  "Write a java program take two int values from user and print greatest among them?",
  "Write a java program a shop will give discount of 10% if the cost of purchased quantity is more than 1000. Ask user for quantity. Suppose, one unit will cost 100. Judge and print total cost for user?",
  "Write a java program a company decided to give bonus of 5% to employee if his/her year of service is more than 5 years. Ask user for their salary and year of service and print the net bonus amount?",
  "Write a java program a school has following rules for grading system: a. Below 25 - F, b. 25 to 45 - E, c. 45 to 50 - D, d. 50 to 60 - C, e. 60 to 80 - B, f. Above 80 - A. Ask user to enter marks and print the corresponding grade?",
  "Write a java program take input of age of 3 people by user and determine oldest and youngest among them?",
  "Write a java program to print absolute value of a number entered by user. e.g., INPUT: 1 OUTPUT: 1, INPUT: -1 OUTPUT: 1?",
  "Write a java program a student will not be allowed to sit in exam if his/her attendance is less than 75%. Take following input from user: Number of classes held, Number of classes attended. And print percentage of class attended. Is student is allowed to sit in exam or not?",
  "Modify the above question to allow student to sit if he/she has medical cause. Ask user if he/she has medical cause or not ('Y' or 'N') and print accordingly?",
  "If x = 2, y = 5, z = 0 then find values of the following expressions: a. x == 2, b. x! = 5, c. x! = 5 && y >= 5, d. z! = 0 || x == 2, e.! (y < 10)?",
  "Write a java program to check whether an entered character is lowercase (a to z) or uppercase (A to Z)?",
  "Write a java program to find the largest of three numbers? 1st Number = 120938, 2nd Number = 25894, 3rd Number = 52244562?",
  "Write a java program to accept a coordinate point in a X-Y coordinate system and determine in which quadrant the coordinate point lies?",
  "Write a java program to find the eligibility of admission for a professional course based on the following criteria: Eligibility Criteria: Marks in Math >=65 and Marks in Phys >=55 and Marks in Chem>=50, Total in all three subject >=190 or Total in Math and Physics >=140?",
  "Write a java program to calculate the roots of a Quadratic Equation? Test Data: a = 1, b = 5, c = 7?",
  "Write a java program to read roll no, name and marks of three subjects and calculate the total, percentage and division?",
  "Write a java program to read temperature in centigrade and display a suitable message according to temperature state below: Temp < 0 then Freezing weather, Temp 0-10 then Very Cold weather, Temp 10-20 then Cold weather, Temp 20-30 then Normal in Temp, Temp 30-40 then Its Hot, Temp >=40 then Its Very Hot?",
  "Write a java program to check whether a triangle is Equilateral, Isosceles or Scalene?",
  "Write a java program to check whether a triangle can be formed by the given value for the angles?",
  "Write a java program to check whether a character is an alphabet, digit or special character?",
  "Write a java program to check whether an alphabet is a vowel or consonant?",
  "Write a program in java to calculate and print the Electricity bill of a given customer. The customer ID, name and unit consumed by the user should be taken from the keyboard and display the total amount to pay to the customer. The charge is as follow: Unit Charge/unit - up to 199 @1.20, 200 and above but less than 400 @1.50, 400 and above but less than 600 @1.80, 600 and above @2.00. If bill exceeds Rs. 400 then a surcharge of 15% will be charged and the minimum bill should be of Rs. 100/-?",
  "Write a java program to check whether a number is negative, positive or zero?",
  "Write a java program to check whether a number is divisible by 5 and 11 or not?",
  "Write a java program to input month number and print number of days in that month?",
  "Write a java program to count total number of notes in given amount?",
  "Write a java program to input basic salary of an employee and calculate its Gross salary according to following: Basic Salary <= 10000: HRA = 20%, DA = 80%, Basic Salary <= 20000: HRA = 25%, DA = 90%, Basic Salary => 20000: HRA = 30%, DA = 95%. HRA: House Rent Allowance, DA: Dearness Allowance?",
  "Write a java program to input electricity unit charges and calculate total electricity bill according to the given condition: For first 50 units Rs. 0.50/unit, For next 100 units Rs. 0.75/unit, For next 100 units Rs. 1.20/unit, For unit above 250 Rs. 1.50/unit. An additional surcharge of 20% is added to the bill?",
  "Discount and Revenue. Revenue can be calculated as the selling price of the product times the quantity sold, i.e. revenue = price × quantity. Write a program that asks the user to enter product price and quantity and then calculate the revenue. If the revenue is more than 5000 a discount is 10% offered. Program should display the discount and net revenue?",
  "Given the length and breadth of a rectangle, write a program to find whether the area of the rectangle is greater than its perimeter. For example, the area of the rectangle with length = 5 and breadth = 4 is greater than its perimeter?",
  "Write a java program that accepts three numbers from the user and check if numbers are in increasing or decreasing order?",
  "Write a Java program to create a simple calculator?",
  "In a company, worker efficiency is determined on the basis of the time required for a worker to complete a particular job. If the time taken by the worker is between 2 – 3 hours, then the worker is said to be highly efficient. If the time required by the worker is between 3 – 4 hours, then the worker is ordered to improve speed. If the time taken is between 4 – 5 hours, the worker is given training to improve his speed, and if the time taken by the worker is more than 5 hours, then the worker has to leave the company. If the time taken by the worker is input through the keyboard, find the efficiency of the worker?",
  "A library charges a fine for every book returned late. For first 5 days the fine is 50 paisa, for 6-10 days fine is one rupee and above 10 days fine is 5 rupees. If you return the book after 30 days your membership will be canceled. Write a program to accept the number of days the member is late to return the book and display the fine or the appropriate message?",
  "Write a program to check whether a triangle is valid or not, when the three angles of the triangle are entered through the keyboard. A triangle is valid if the sum of all the three angles is equal to 180 degrees?",
  "Take input from user in centimeters and convert it in meters or kilometers based on user's choice?",
  "Write a java Program to take the hours and minutes as input by the user and the show that whether it is AM or PM?",
  "Write a java program to check whether the last digit of a number is divisible by 3 or not?",
  "Create a mini calculator to perform basic operations like addition, subtraction, multiplication, division?",
]
    ),
    
    Assignment(
      id: "5",
      title: "While Loop",
      subject: "Programming Fundamentals",
      difficulty: "Beginner",
      questions: [
  "Write a Java program to display the first 10 natural numbers.",
  "Write a Java program to find the sum of the first 10 natural numbers.",
  "Write a Java program to display n terms of natural numbers and their sum.",
  "Write a Java program to display n terms of odd natural numbers and their sum.",
  "Write a program to find the factorial of a given number.",
  "Write a Java program to print the first 10 numbers and their squares.",
  "Write a Java program to read 10 numbers from keyboard and find their sum and average.",
  "Write a Java program to display the cube of numbers up to a given integer.",
  "Write a Java program to display the multiplication table of a given integer.",
  "Write a Java program to display the multiplication tables vertically from 1 to n.",
  "Write a program to input numbers until the user stops and then display the count of positive, negative, and zero values.",
  "Write a Java program to check whether a number is prime using a while loop.",
  "Write a Java program to display number names of each digit (e.g., 231 → two three one).",
  "Write a Java program to count the number of digits in a number.",
  "Write a Java program to find the first and last digit of a number.",
  "Write a Java program to find the sum of the first and last digit of a number.",
  "Write a Java program to swap the first and last digits of a number.",
  "Write a Java program to calculate the sum of digits of a number.",
  "Write a Java program to calculate the product of digits of a number.",
  "Write a Java program to enter a number and print its reverse without using String.",
  "Write a Java program to check whether a number is a palindrome.",
  "Write a Java program to check whether a number is a Strong number.",
  "Write a Java program to check whether a number is an Armstrong number.",
  "Write a Java program to find the frequency of each digit in a given integer.",
  "Write a Java program to print all ASCII characters with their values.",
  "Write a Java program to find all factors of a number.",
  "Write a Java program to find the LCM of two numbers.",
  "Write a Java program to find the HCF (GCD) of two numbers.",
]

    ),
    Assignment(
      id: "6",
      title: "Do While Loop",
      subject: "Programming Fundamentals",
      difficulty: "Beginner",
      questions: [
  "Write a Java program to display the first 10 natural numbers?",
  "Two numbers are entered through the keyboard. Write a Java program to find the value of one number raised to the power of another. (Do not use Java built-in method)?",
  "Write a Java program that prompts the user to input an integer and then outputs the number with the digits reversed. For example, if the input is 12345, the output should be 54321?",
  "Write a Java program that reads a set of integers, and then prints the sum of the even and odd integers?",
  "Write a Java program that prompts the user to input a positive integer. It should then output a message indicating whether the number is a prime number?",
  "Write a Java program to find the sum of first 10 natural numbers?",
  "Write a Java program to display n terms of natural number and their sum?",
  "Write a Java program to read 10 numbers from keyboard and find their sum and average?",
  "Write a Java program to display the cube of the number up to given an integer?",
  "Write a Java program to display the multiplication table vertically from 1 to n?",
  "Write a Java program to display the n terms of odd natural number and their sum?",
  "Write a Java program to count number of digits in a number?",
  "Write a Java program to find first and last digit of a number?",
  "Write a Java program to find sum of first and last digit of a number?",
  "Write a Java program to swap first and last digits of a number?",
  "Write a Java program to calculate sum of digits of a number?",
  "Write a Java program to calculate product of digits of a number?",
  "Write a Java program to enter a number and print its reverse?",
  "Write a Java program to check whether a number is palindrome or not?",
  "Write a Java program to find frequency of each digit in a given integer?",
  "Write a Java program to enter a number and print it in words up to 10?",
  "Write a Java program to print all ASCII character with their values?",
  "Write a Java program to find all factors of a number?",
  "Write a Java program to check whether a number is Strong number or not?",
  "Write a Java program to check whether a number is Armstrong number or not?",
  "Write a program to enter the numbers till the user wants and at the end it should display the count of positive, negative and zeros entered.",
  "Write a program to enter the numbers till the user wants and at the end the program should display the largest and smallest numbers entered.",
]
    ),
    
    Assignment(
      id: "9",
      title: "For Loop",
      subject: "Programming Fundamentals",
      difficulty: "Beginner",
questions: [
  "Write a Java program to display the first 10 natural numbers?",
  "Write a Java program to find the sum of first 10 natural numbers?",
  "Write a Java program to display n terms of natural number and their sum?",
  "Write a Java program to read 10 numbers from keyboard and find their sum and average?",
  "Write a Java program to display the cube of the number up to given an integer?",
  "Write a Java program to display the multiplication table of a given integer?",
  "Write a Java program to display the multiplication table vertically from 1 to n?",
  "Write a Java program to display the n terms of odd natural number and their sum?",
  "Write a Java program to display the n terms of even natural number and their sum?",
  "Write a Java program to find the sum of the series [ 1-X^2/2! +X^4/4! - .........]?",
  "Write a Java program to display the n terms of harmonic series and their sum?",
  "Write a Java program to display the sum of the series [ 9 + 99 + 999 + 9999 ...]?",
  "Write a Java program to display the sum of the series [ 1+x+x^2/2! +x^3/3! +....]?",
  "Write a Java program to find the sum of the series [ x +x^3 + x^5 + ......]?",
  "Write a Java program to display the n terms of square natural number and their sum?",
  "Write a Java program to find the sum of the series 1 +11 + 111 + 1111 + .. n terms?",
  "Write a Java program to find the perfect numbers within a given number of ranges?",
  "Write a Java program to find the prime numbers within a range of numbers?",
  "Write a Java program to display the first n terms of Fibonacci series?",
  "Write a Java program to display the number in reverse order?",
  "Write a Java program to check whether a number is a palindrome or not?",
  "Write a Java program to find the number and sum of all integer between 100 and 200 which are divisible by 9?",
  "Write a Java program to convert a decimal number into binary without using an array?",
  "Write a Java program to convert a binary number into a decimal number without using array, function and while loop?",
  "Write a Java program to find out the sum of an Arithmetic progression series?",
  "Write a Java program to find the Sum of GP series?",
  "Write a Java program to convert a binary number to octal?",
  "Write a Java program to Check Whether a Number can be Express as Sum of Two Prime Numbers?",
  "Write a Java program to print a string in reverse order?",
  "Write a Java program to find the length of a string without using the library function?",
  "Write a Java program to count number of digits in a number?",
  "Write a Java program to find the factorial value of any number entered through the keyboard?",
  "Two numbers are entered through the keyboard. Write a Java program to find the value of one number raised to the power of another. (Do not use Java built-in method)?",
  "Write a Java program that reads a set of integers, and then prints the sum of the even and odd integers?",
  "Write a Java program to enter the numbers till the user wants and at the end it should display the count of positive, negative and zeros entered?",
  "Write a Java program to print out all Armstrong numbers between 1 and 500. If sum of cubes of each digit of the number is equal to the number itself, then the number is called an Armstrong number. For example, 153 = (1 * 1 * 1) + (5 * 5 * 5) + (3 * 3 * 3)?",
  "Write a Java program to print following:\n **********\n**********\n**********\n**********\n\n *\n**\n***\n****\n*****\n\n *\n**\n***\n****\n*****\n\n *****\n****\n***\n**\n*\n\n *\n***\n*****\n*******\n*********\n\n 1\n222\n33333\n4444444\n555555555\n\n 1\n212\n32123\n4321234\n543212345\n\n *****\n ****\n  ***\n   **\n    *",
  "Write a Java program to enter the numbers till the user wants and at the end the program should display the largest and smallest numbers entered?",
  "Write a Java program that prompts the user to input an integer and then outputs the number with the digits reversed. For example, if the input is 12345, the output should be 54321?",
  "Write a Java program that prompts the user to input a positive integer. It should then output a message indicating whether the number is a prime number?",
  "Write a Java program to display the pattern like a diamond?\n    *\n   ***\n  *****\n *******\n*********\n *******\n  *****\n   ***\n    *",
]
    ),

    Assignment(
      id: "8",
      title: "Switch Statement",
      subject: "Programming Fundamentals",
      difficulty: "Beginner",
questions: [
  "Write a java program to print day of week name using switch case?",
  "Write a java program print total number of days in a month using switch case?",
  "Write a java program to check whether an alphabet is vowel or consonant using switch case?",
  "Write a java program to check whether a given character is alphabet, number, or special character?",
  "Write a java program to find maximum between two numbers using switch case?",
  "Write a java program to check whether a number is even or odd using switch case?",
  "Write a java program to check whether a number is positive, negative or zero using switch case?",
  "Write a java program to find roots of a quadratic equation using switch case?",
  "Write a java program to create Simple Calculator using switch case?",
  "Write a java program to print number between 1 to 10 in character format using switch-case?",
  "Write a java program to accept id from user to confirm department using switch-case? Department Id: Computer Science CS-1, Software Engineering SE-2, Information Technology IT-3, Artificial Intelligence AI-4, Anonymous Department AD-0?",
  "Write a java program to check password is correct or incorrect using switch-case?",
  "Write a java program to display user details using id?",
  "Write a java program to read gender (M/F) and print corresponding gender using switch?",
  "Write a java program to read any digit, display in the word, up to 20?",
  "Write a java Program to find the maximum between three numbers using the switch statement?",
  "Write a program to print remark according to the grade obtained using switch statement?",
  "Write a program to check whether a person is eligible to vote or not using switch statement?",
  "Take a long type as input, find its last digit and do the following computations accordingly: if last digit is 1, divide number by 10, if last digit is 5, divide number by 100, if last digit is 9, divide number by 1000, if last digit is any other than above described, divide number by 20?",
  "Take char input from user (either in uppercase or lowercase) print the relative color using switch case, following VIBGYOR spectrum?",
]
    ),
    Assignment(
      id: "10",
      title: "Arrays",
      subject: "Data Structures",
      difficulty: "Intermediate",
      questions: [
  "Write a Java program to sort an numeric array and a string array.",
  "Write a Java program to sum values of an array.",
  "Write a Java program to calculate average value of an array elements.",
  "Write a Java program to test if an array contains a certain value.",
  "Write a Java program to find the index of an array element.",
  "Write a Java program to remove a specific element from an array.",
  "Write a Java program to copy an array by iterating the array.",
  "Write a Java program to insert an element (specific position) into an array.",
  "Write a Java program to find the maximum and minimum value of an array.",
  "Write a Java program to reverse an array of integer values.",
  "Write a Java program to find the duplicate values of an array of integer values.",
  "Write a Java program to find the duplicate values of an array of string values.",
  "Write a Java program to find the common elements between two arrays (string values).",
  "Write a Java program to find the common elements between two arrays of integers.",
  "Write a Java program to remove duplicate elements from an array.",
  "Write a Java program to find the second largest element in an array.",
  "Write a Java program to find the second smallest element in an array.",
  "Write a Java program to add two matrices of same size.",
  "Write a Java program to convert an array to ArrayList.",
  "Write a Java program to convert an ArrayList to an array.",
  "Write a Java program to find all pairs of elements in an array whose sum is equal to a specified number.",
  "Write a Java program to test the equality of two arrays.",
]
    ),

    Assignment(
      id: "11",
      title: "ArrayLinked_List",
      subject: "Data Structures",
      difficulty: "Intermediate",
      questions: [
  "Creating and Adding Elements: Create an ArrayList of your favorite movies. Use add(E e) to add 5 movie names, then use add(int index, E element) to insert a movie at position 2. Print the entire list.",
  "Accessing and Updating: Use get(int index) to print the 3rd movie from your ArrayList. Use set(int index, E element) to replace the 2nd movie with another title. Display the modified list.",
  "Removing Elements: Use remove(int index) to remove the movie at index 1, then use remove(Object o) to remove a movie by its name. Print the updated list.",
  "Searching and Checking: Use contains(Object o), indexOf(Object o), and lastIndexOf(Object o) on your movie ArrayList. Display results for each method.",
  "Size and Empty Checks: Demonstrate the use of size(), isEmpty(), and clear() methods on your ArrayList. Show the output after each operation.",
  "Iteration: Iterate through your ArrayList using three different methods: for loop with get(i), Enhanced for-each loop, and Iterator using iterator() method. Display results from each approach.",
  "Sorting and Copying: Create an ArrayList<Integer> with numbers. Use Collections.sort(list), Collections.reverse(list), and clone(). Print the list before and after sorting and reversing.",
  "Conversion and Sublist: Use toArray() to convert your ArrayList to an array, and use subList(int fromIndex, int toIndex) to extract a portion of the list. Display both results.",
  "Basic Add and Retrieve: Create a LinkedList<String> of cities. Use add(E e), addFirst(E e), and addLast(E e) to add cities. Then use getFirst() and getLast() to print the first and last cities.",
  "Remove Operations: Use removeFirst(), removeLast(), and remove(Object o) on your LinkedList of cities. Display the updated list after each removal operation.",
  "Stack and Queue Behavior: Use LinkedList as both Queue and Stack. Demonstrate Queue operations: offer(), poll(), peek(). Then demonstrate Stack operations: push(), pop(). Show the difference between both modes.",
  "Searching and Checking: Use contains(Object o), indexOf(Object o), lastIndexOf(Object o), and isEmpty() on your LinkedList. Print results accordingly.",
  "Iteration: Iterate through your LinkedList using Enhanced for loop, Iterator, and descendingIterator() to print in reverse order.",
  "Combining Lists: Create two LinkedLists. Use addAll(Collection c) to merge them. Use removeAll(Collection c) to remove duplicates.",
  "Conversion and Cloning: Use toArray() and clone() on your LinkedList. Print both to show the difference.",
  "Bonus Challenge: Write a program that reads student names into an ArrayList, moves them into a LinkedList in reverse order, removes duplicates, sorts alphabetically, and prints the final list using an Iterator."
]
    ),
  ];

  // Helper method to get assignment by ID
  static Assignment? getAssignmentById(String id) {
    try {
      return allAssignments.firstWhere((assignment) => assignment.id == id);
    } catch (e) {
      return null;
    }
  }

  // Helper method to get assignment by title
  static Assignment? getAssignmentByTitle(String title) {
    try {
      return allAssignments.firstWhere((assignment) => assignment.title == title);
    } catch (e) {
      return null;
    }
  }
}