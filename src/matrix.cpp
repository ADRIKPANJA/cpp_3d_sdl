// matrix.cpp

#include <array>
#include <cmath>
#include "matrix.h"

const double PI = (4 * atan(1));

// Use the namespace
using namespace std;

// Function to get the projection matrix
array<array<double, 4>, 4> ProjectionMatrix(double fov, double aspect, double near, double far) {
    double temp = (1 / (tan((fov * (PI/180))/2)));
    return array<array<double, 4>, 4> {{
        {temp/aspect, 0, 0, 0},
        {0, temp, 0, 0},
        {0, 0, (near + far)/(far - near), (2 * near * far)/(near - far)},
        {0, 0, -1, 0}
    }};
}

// Function to multiply the matrices
array<double, 4> MultiplyMatrix(const array<array<double, 4>, 4>& matrix, const array<double, 4>& point) {
    array<double, 4> result = {0.0, 0.0, 0.0, 0.0};
    for (int i = 0; i < 4; ++i) {
        result[i] = (matrix[i][0] * point[0]) +
                    (matrix[i][1] * point[1]) +
                    (matrix[i][2] * point[2]) +
                    (matrix[i][3] * point[3]);
    }
    return result;
}