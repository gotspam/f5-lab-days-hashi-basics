# https://devcentral.f5.com/s/articles/ratio-load-balancing-using-rand-function
when CLIENT_ACCEPTED { 
   # Send 30% of connections to a separate pool
   if { rand() < 0.30 } { 
      pool green_pool
   } 
}