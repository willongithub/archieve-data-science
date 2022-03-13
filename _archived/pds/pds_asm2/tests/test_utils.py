from dataviwer import demo
# import dataviwer.utils as demo


# def calc_addition(a, b):
#     return a + b
 
 
# def calc_multiply(a, b):
#     return a * b
     
 
# def calc_substraction(a, b):
#     return a - b

def test_calc_addition():
    output = demo.calc_addition(2,4)
    assert output == 6
 
def test_calc_substraction():
    output = demo.calc_substraction(2, 4)
    assert output == -2
     
def test_calc_multiply():
    output = demo.calc_multiply(2,4)
    assert output == 8

# def test_demo():
#     assert 1 == 1

# def test_output():
#     assert len(utils.get_output(utils.Classifier('knn'))) == 3