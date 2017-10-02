# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                          Direction Cosine Matrices
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

"""
### function create_rotation_matrix!{T}(dcm::Array{Float64, 2}, angle::T, axis::Char)

Create a rotation matrix that rotates a coordinate frame about a specified axis.

##### Args

* dcm: (OUTPUT) Pre-allocated matrix in which the rotation matrix that rotates
the coordinate frame about 'axis' will be written.
* angle: Angle.
* axis: Axis, must be 'x', 'X', 'y', 'Y', 'z', or 'Z'.

"""

function create_rotation_matrix!{T}(dcm::Array{Float64, 2}, angle::T, axis::Char)
    cos_angle = cos(angle)
    sin_angle = sin(angle)

    if (axis == 'x') || (axis == 'X')
        dcm[1,1] = 1
        dcm[1,2] = 0
        dcm[1,3] = 0

        dcm[2,1] = 0
        dcm[2,2] = cos_angle
        dcm[2,3] = sin_angle

        dcm[3,1] = 0
        dcm[3,2] = -sin_angle
        dcm[3,3] = cos_angle
    elseif (axis == 'y') || (axis == 'Y')
        dcm[1,1] = cos_angle
        dcm[1,2] = 0
        dcm[1,3] = -sin_angle

        dcm[2,1] = 0
        dcm[2,2] = 1
        dcm[2,3] = 0

        dcm[3,1] = sin_angle
        dcm[3,2] = 0
        dcm[3,3] = cos_angle
    elseif (axis == 'z') || (axis == 'Z')
        dcm[1,1] = cos_angle
        dcm[1,2] = sin_angle
        dcm[1,3] = 0

        dcm[2,1] = -sin_angle
        dcm[2,2] = cos_angle
        dcm[2,3] = 0

        dcm[3,1] = 0
        dcm[3,2] = 0
        dcm[3,3] = 1
    else
        error("axis must be X, Y, or Z");
    end

    nothing
end

"""
### function create_rotation_matrix{T}(angle::T, axis::Char)

Create a rotation matrix that rotates a coordinate frame about a specified axis.

##### Args

* angle: Angle.

* axis: Axis, must be 'x', 'X', 'y', 'Y', 'z', or 'Z'.

##### Returns

* The rotation matrix that rotates the coordinate frame about 'axis'.

"""

function create_rotation_matrix{T}(angle::T, axis::Char)
    # Allocate the rotation matrix.
    dcm = Array{T}(3,3)

    # Fill the rotation matrix.
    create_rotation_matrix!(dcm, angle, axis)

    # Return the rotation matrix.
    dcm
end


"""
### function dcm2angle{T}(dcm::Array{T,2}, rot_seq::AbstractString="ZYX")

Convert a DCM to Euler Angles given a rotation sequence.

##### Args

* DCM: Direction Cosine Matrix.
* rot_seq: Rotation sequence.

##### Returns

* The Euler angles.

"""

function dcm2angle{T}(dcm::Array{T,2}, rot_seq::AbstractString="ZYX")
    # Check if the dcm is a 3x3 matrix.
    if (size(dcm,1) != 3) || (size(dcm,2) != 3)
        throw(ArgumentError)
    end

    # Check if rot_seq has at least three characters.
    if length(rot_seq) < 3
        throw(RotationSequenceError)
    end

    # For each rotation sequence, compute the euler angles.
    rot_seq = uppercase(rot_seq)

    if( startswith(rot_seq, "ZYX") )

        EulerAngles(atan2(+dcm[1,2],+dcm[1,1]),
                     asin(-dcm[1,3]),
                    atan2(+dcm[2,3],+dcm[3,3]),
                    rot_seq)

    elseif( startswith(rot_seq, "XYX") )

        EulerAngles(atan2(+dcm[1,2],-dcm[1,3]),
                     acos(+dcm[1,1]),
                    atan2(+dcm[2,1],+dcm[3,1]),
                    rot_seq)

    elseif( startswith(rot_seq, "XYZ") )

        EulerAngles(atan2(-dcm[3,2],+dcm[3,3]),
                     asin(+dcm[3,1]),
                    atan2(-dcm[2,1],+dcm[1,1]),
                    rot_seq)

    elseif( startswith(rot_seq, "XZX") )

        EulerAngles(atan2(+dcm[1,3],+dcm[1,2]),
                     acos(+dcm[1,1]),
                    atan2(+dcm[3,1],-dcm[2,1]),
                    rot_seq)

    elseif( startswith(rot_seq, "XZY") )

        EulerAngles(atan2(+dcm[2,3],+dcm[2,2]),
                     asin(-dcm[2,1]),
                    atan2(+dcm[3,1],+dcm[1,1]),
                    rot_seq)

    elseif( startswith(rot_seq, "YXY") )

        EulerAngles(atan2(+dcm[2,1],+dcm[2,3]),
                     acos(+dcm[2,2]),
                    atan2(+dcm[1,2],-dcm[3,2]),
                    rot_seq)

    elseif( startswith(rot_seq, "YXZ") )

        EulerAngles(atan2(+dcm[3,1],+dcm[3,3]),
                     asin(-dcm[3,2]),
                    atan2(+dcm[1,2],+dcm[2,2]),
                    rot_seq)

    elseif( startswith(rot_seq, "YZX") )

        EulerAngles(atan2(-dcm[1,3],+dcm[1,1]),
                     asin(+dcm[1,2]),
                    atan2(-dcm[3,2],+dcm[2,2]),
                    rot_seq)

    elseif( startswith(rot_seq, "YZY") )

        EulerAngles(atan2(+dcm[2,3],-dcm[2,1]),
                     acos(+dcm[2,2]),
                    atan2(+dcm[3,2],+dcm[1,2]),
                    rot_seq)

    elseif( startswith(rot_seq, "ZXY") )

        EulerAngles(atan2(-dcm[2,1],+dcm[2,2]),
                     asin(+dcm[2,3]),
                    atan2(-dcm[1,3],+dcm[3,3]),
                    rot_seq)

    elseif( startswith(rot_seq, "ZXZ") )

        EulerAngles(atan2(+dcm[3,1],-dcm[3,2]),
                     acos(+dcm[3,3]),
                    atan2(+dcm[1,3],+dcm[2,3]),
                    rot_seq)

    elseif( startswith(rot_seq, "ZYZ") )

        EulerAngles(atan2(+dcm[3,2],+dcm[3,1]),
                     acos(+dcm[3,3]),
                    atan2(+dcm[2,3],-dcm[1,3]),
                    rot_seq)

    else
        throw(RotationSequenceError)
    end
end
