Rotation conversions:

Basic Idea:
Quat <--> Exp. Map <--> Matrix



"Quat <--> Exp. Map": 
        q = (cos(theta/2), r0 * sin(theta/2))
 (mnemonic: when theta=0, q reduces to a scalar)

"Exp. Map --> Matrix": 
        R = e^[r] 
          = I + sin(theta) [r0] + (1-cos(theta)) [r0]^2
        where [r] is a 3x3 matrix such that [r]x == cross_product(r, x)
        [r] is anti-symmetric 
        the upper triangle of [r] is  (0 -r3 r2; 0 0 -r1; 0 0 0)
        [r0]^3 = - [r0]

"Matrix --> Exp. Map":
        Tr(R) = 1 + 2 *cos(theta)
        R - R^T = e^[r] - e^[-r] = 2 * sin(theta) [r0]


Ambiguities:

Matrix: no ambiguity

Quat: q==-q (the two opposite points on the 4-dim sphere represent the same rotation)

Exp Map: (1) (r0,theta)==(-r0, -theta)
         (2) (r0,theta)==(r0, theta+2pi)
==> exp map is unique if theta is constrained in [0,pi]

