vpc_cidr = "192.168.0.0/16"

public-subnets = {
  public-a = {
    az   = "ap-northeast-2a",
    cidr = "192.168.140.0/24"
  }
}

private-subnets = {
  private-a = {
    az   = "ap-northeast-2a",
    cidr = "192.168.170.0/24"
  }
}
