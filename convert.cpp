#include <iostream>
#include <iomanip>
#include <fstream>
#include "vector"
#include "queue"
#include "string"
#include "math.h"
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "sstream"
using namespace std;

double longi(int l){
	return double(l)/1000 + 40.48;
}
double lati(int l){
	return double(l)/1000 - 74.27;
}

int revlongi(double l){
	return floor( (l - 40.48) * 1000 );
}
int revlati(double l){
	return floor ( (l + 74.27) * 1000 );
}
int main(int argc, char const *argv[])
{
	int l_u_0,l_u_1;
	l_u_0 = 281;
	l_u_1 = 279;
	double l_u_0_long = longi(l_u_0);
	double l_u_1_la = lati(l_u_1);

	int r_d_0 = 271;
	int r_d_1 = 289;
	double r_d_0_la = lati(272);
	double r_d_1_long = longi(270);

	//cout << r_d_1_long<< " " << r_d_0_la << endl;
	cout << revlongi(40.747705) << " " << revlati(-73.978059)<< endl;
	/* 40.760982, -73.998829 
		280 271
	   40.747705, -73.978059
	   */
	return 0;
}