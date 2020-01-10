resource "aws_iam_role_policy" "ec2_s3_policy" {
  name = "ec2-s3-policy"
  role = "${aws_iam_role.ec2_s3_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "S3:ListBucket",
        "S3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::tal2020brownbagdemo/*"

    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_s3_instance_profile" {
  name = "ec2-s3-instance-profile"
  role = "${aws_iam_role.ec2_s3_role.name}"
}

resource "aws_iam_role" "ec2_s3_role" {
    name            = "ec2-s3-role"
    description     = "EC2 role to access TAL S3 Bucket"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}
