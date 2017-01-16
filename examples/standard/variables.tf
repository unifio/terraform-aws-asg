# Input Variables

## Resource tags
variable "stack_item_label" {
  type = "string"
}

variable "stack_item_fullname" {
  type = "string"
}

## VPC parameters
variable "vpc_id" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "lan_subnet_ids" {
  type = "string"
}

## LC parameters
variable "ami" {
  type = "string"
}

variable "instance_type" {
  type = "string"
}

variable "instance_profile" {
  type = "string"
}

variable "key_name" {
  type = "string"
}

## ASG parameters
variable "cluster_max_size" {
  type = "string"
}

variable "cluster_min_size" {
  type = "string"
}

variable "min_elb_capacity" {
  type = "string"
}

## ELB parameters
variable "internal" {
  type = "string"
}

variable "cross_zone_lb" {
  type = "string"
}

variable "connection_draining" {
  type = "string"
}
