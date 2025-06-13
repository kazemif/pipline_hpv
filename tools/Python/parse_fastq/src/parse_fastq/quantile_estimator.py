#!/usr/bin/env python

"""
Program: quantile_estimator.py

Date of creation: 09th of August 2024 
version: 1.0
Author: Fauchois A.
Site: Virology department, AP-HP Pitié-Salpêtrière, Paris, France
"""

#Import modules================================================================
import sys

#Import class==================================================================

#Class to estimate quantile using P2 algorithm---------------------------------
class P2QuantileEstimator:
    #Function to initialize class
    def __init__(self, p, x):
        """
        This function allows to initialize P2QuantileEstimator algorithm

        PARAM:
        p: desired quantile
        x: the first five observed values
        """
        #Define a quantile arguments
        self.quantile = p
        #Test if x is an array of length 5
        if len(x) != 5:
            sys.exit("ERROR: You need to provide a list of length 5 to initialize P2QuantileEstimator class")
        #Define marker values
        tempo = x
        tempo.sort()
        self.q =  x
        #Define marker position
        self.n = list(range(5))
        #Define desired marker position
        self.n_prime = [0, 2*p, 4*p, 2 + 2*p, 4]
        #Precalculate incrementation
        self.dn_prime = [0, p/2, p, (1 + p)/2, 1]
        #Define array size
        self.array_size = len(x)
    
    #Function to get sign from number
    def get_sign(self, x):
        """
        This function allows to extract the sign of a provided value
        
        PARAM:
        x: a value to extract a sign
        """
        if x > 0:
             return 1
        elif x < 0:
             return -1
        else:
             return 0
        
    #Function to get estimated quantile by polynomial interpolation    
    def parabolic(self, i, sign):
         """
         This function allows to adjust markers values using a parabolic
         interpolation

         PARAM:
         index: index value from the loop
         sign: an extracted signfrom difference between n_primer and n at i
         """
         div_1 = sign  / (self.n[i + 1] - self.n[i - 1])
         factor_1 = (self.n[i] - self.n[i - 1] + sign) * ((self.q[i + 1] - self.q[i]) / (self.n[i + 1] - self.n[i]))
         factor_2 = (self.n[i + 1] - self.n[i] - sign) * ((self.q[i] - self.q[i -1]) / (self.n[i] - self.n[i -1]))
         q_prime = self.q[i] + div_1 * (factor_1 + factor_2)
         return q_prime
    
    #Function to get estimated quantile by linear interpolation
    def linear(self, i,  sign):
         """
         This function allows to adjust markers values using a linear interpolation

         PARAM:
         index: index value from the loop
         sign: an extracted signfrom difference between n_primer and n at i
         """
         q_prime = self.q[i] + sign * (self.q[i + sign] - self.q[i]) / (self.n[i + sign] - self.n[i])
         return q_prime

    #Function to add values
    def add_value(self, x):
        """
        This function allows to add a new value

        PARAM:
        x: a new value to add
        """
        #Looking for a k index where qk < x < qk+1
        if x < self.q[0]:
            self.q[0] = x
            k = 0
        elif x < self.q[1]:
            k = 0
        elif x < self.q[2]:
                    k = 1
        elif x < self.q[3]:
            k = 2
        elif x < self.q[4]:
            k = 3
        else:
            self.q[4] = x
            k = 3
        #Update marker position
        for i in list(range(k + 1, 5)):
            self.n[i] += 1
        
        #Update desired marker position
        for i in list(range(5)):
            self.n_prime[i] += self.dn_prime[i]

        #Adjust non-extreme marker values (q) and positions (n) for i in 1,2,3
        for i in list(range(1, 4)):
            ##Compute the difference between desired and real marker position
            d = self.n_prime[i] - self.n[i]
            if (d >= 1 and (self.n[i + 1] - self.n[i] > 1) > 1) or (d <= -1 and (self.n[i - 1] - self.n[i]) < -1):
                dInt = self.get_sign(d)
                qs = self.parabolic(i, dInt)
                #Use parabolic interpolation if qs value are between qi and qi+1
                if (self.q[i - 1] < qs and qs < self.q[i + 1]):
                    self.q[i] = qs
                #Else use a linear interpolation
                else:
                     self.q[i] = self.linear(i, dInt)
                self.n[i] += dInt
        #Update array size
        self.array_size += 1

    #Function to get quantile    
    def get_quantile(self):
        """
        This function allows to get desired quantile
        """
        if self.array_size <= 5:
            self.q.sort()
            index = round((self.array_size - 1) * self.quantile)
            return self.q[index]
        else:
            return self.q[2]