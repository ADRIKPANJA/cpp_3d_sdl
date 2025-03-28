// matrix.h

#ifndef MATRIX_H
#define MATRIX_H

#include <array>
#include <cmath>

const double PI = (4 * atan(1));

// Use the namespace
using namespace std;

// Function to get the projection matrix
array<array<double, 4>, 4> ProjectionMatrix(double fov, double aspect, double near, double far);

// Function to multiply the matrices
array<double, 4> MultiplyMatrix(const array<array<double, 4>, 4>& matrix, const array<double, 4>& point);

#endif