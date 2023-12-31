# Flippable 2D IK Targets

## Forked from [this repository](https://github.com/elliottTreinen/IKTarget)

Custom classes for Godot 4.2.1 for various IK types that don't throw a tantrum when you flip the containing tree.

Can be janky.

## FABRIK script not done yet, sorry :(

## Setting up Two Bone IK

- All sprites need to be pointing to the right (see first image below for example).
- Sprites should be moved into position only using the OFFSET, flip_h or flip_v, **NOT** transform
- Segments of the IK chain ALSO need to point to the right.

- Set up the base Two-bone IK in the skeleton's modification stack (see 6. in the images below), using a Marker2D as the target node
- Apply the Flippable 2Bone IK script to the Marker2D target
- In the Marker2D's inspector view, set the 'end bone' to the end bone on the 2Bone IK chain.

Now, when you flip a parent node of the skeleton, the IK should not totally flip out! Well, hopefully.

Here's a look at a working setup, flipping the root Node2D should successfully mirror the skeleton:

![image](/Doc/Part1.jpg)

![image](/Doc/Part2.jpg)

![image](/Doc/Part3.jpg)

![image](/Doc/Part4.jpg)

![image](/Doc/Part5.jpg)

