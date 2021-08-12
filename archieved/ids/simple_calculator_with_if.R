# IDS Lab Week 3 Exercise 4
# Simple calculator with "if" statement

# Simple Calculator
print("Select operation.")
print("1.Add")
print("2.Subtract")
print("3.Multiply")
print("4.Divide")

# Your choice
choice = as.integer(readline(prompt = "Enter your choice
(1/2/3/4):"))
num1 = as.numeric(readline(prompt = "Enter the first number: "))
num2 = as.numeric(readline(prompt = "Enter the second number: "))

# Which operation?
if(choice == 1){
  print(paste(num1,"+",num2,"=", num1+num2))
}else if(choice == 2){
  print(paste(num1,"-",num2,"=", num1-num2))
}else if(choice == 3){
  print(paste(num1,"x",num2,"=", num1*num2))
}else if(choice == 4){
  print(paste(num1,"/",num2,"=", num1/num2))
}else{
  print("Wrong choice!")
}
