resource "bigip_sys_ntp" "ntp1" {
  description = "/Common/NTP1"
  servers = ["time.google.com"]
  timezone = "America/Los_Angeles"
}

resource "bigip_sys_dns" "dns1" {
  description = "/Common/DNS1"
  name_servers = ["8.8.8.8"]
  number_of_dots = 2
  search = ["f5.com"]
}

resource "bigip_net_vlan" "vlan1" {
  name = "/Common/internal"
  interfaces {
    vlanport = 1.1
    tagged = false
  }
}

resource "bigip_net_vlan" "vlan2" {
  name = "/Common/external"
  interfaces {
    vlanport = 1.2
    tagged = false
  }
}

resource "bigip_net_selfip" "selfip1" {
   name = "/Common/internalselfIP"
   ip = "10.1.10.6/24"
   vlan = "/Common/internal"
   depends_on = [bigip_net_vlan.vlan1]
}

resource "bigip_net_selfip" "selfip2" {
   name = "/Common/externalselfIP"
   ip = "10.1.20.6/24"
   vlan = "/Common/external"
   depends_on = [bigip_net_vlan.vlan2]
}