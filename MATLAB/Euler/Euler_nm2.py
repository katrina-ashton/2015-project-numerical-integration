###

# ODE: y''(t) = f(t, y(t))   y(t_0) = y_0

# Equation (forward): y_(n+1) = y_n + h*f(t_n, y_n)

# z(t) = y'(t)
# y''(t) -> y'(t) = z(t) -> y(t)

# Input: f(t, y) and y_0
# Let f(t, y) = y

###


def f(t_n, y_n):
    return -1*y_n

def euler_nm_list(y_n, z_n, t_0, h, t_max):
    n = 0
    results = []
    t_n = t_0 + n*h

    while t_n <= t_max:
        t_y_pair = (t_n, y_n)

        results.append(t_y_pair)
        
        n += 1

        z_n = z_n + h*f(t_n, y_n)
        
        y_n = y_n + h*z_n

        t_n = t_0 + n*h

    return results

def euler_nm_csv(y_n, z_n, t_0, h, t_max, filename):
    n = 0
    results = open(filename, "w")
    t_n = t_0 + n*h

    while t_n <= t_max:
        print(t_n, ",", y_n, sep = "", file = results)
        
        n += 1

        z_n = z_n + h*f(t_n, y_n)

        y_n = y_n + h*z_n

        t_n = t_0 + n*h

    results.close()

###

y_n = 0
z_n = 1
t_0 = 0
h = 0.75
t_max = 100

filename = "euler_nm2.csv"

###

#results = euler_nm_list(y_n, z_n, t_0, h, t_max)
#print(results)
    
euler_nm_csv(y_n, z_n, t_0, h, t_max, filename)
