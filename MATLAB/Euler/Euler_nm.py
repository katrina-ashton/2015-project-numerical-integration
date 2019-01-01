###

# ODE: y'(t) = f(t, y(t))   y(t_0) = y_0

# Equation (forward): y_(n+1) = y_n + h*f(t_n, y_n)

# Input: f(t, y) and y_0
# Let f(t, y) = y

###

def f(t_n, y_n):
    return y_n

def euler_nm_list(y_n, t_0, h, t_max):
    n = 0
    results = []
    t_n = t_0 + n*h

    while t_n <= t_max:
        t_y_pair = (t_n, y_n)

        results.append(t_y_pair)
        
        n += 1

        y_n = y_n + h*f(t_n, y_n)

        t_n = t_0 + n*h

    return results

def euler_nm_csv(y_n, t_0, h, t_max, filename):
    n = 0
    results = open(filename, "w")
    t_n = t_0 + n*h

    while t_n <= t_max:
        print(t_n, ",", y_n, sep = "", file = results)
        
        n += 1

        y_n = y_n + h*f(t_n, y_n)

        t_n = t_0 + n*h

    results.close()

###

y_n = 1
t_0 = 0
h = 0.25
t_max = 4

filename = "euler_nm.csv"

###

results = euler_nm_list(y_n, t_0, h, t_max)
print(results)
    
euler_nm_csv(y_n, t_0, h, t_max, filename)
