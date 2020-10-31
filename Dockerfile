FROM alpine:3.12
RUN apk update \
	&& apk add curl \
	&& mkdir -p /etc/overture \
	&& wget https://github.com/shawn1m/overture/releases/download/v1.6.1/overture-linux-amd64.zip \
	&& unzip -d /etc/overture overture-linux-amd64.zip \
	&& cd /etc/overture \
	&& wget https://gist.githubusercontent.com/lmc999/2a6c7b86634b6fc0009ea71c7f76bf5d/raw/9729c706980892ba8bfd24641ab879d412059840/config.json -O config.json \
	&& wget https://raw.githubusercontent.com/HMBSbige/Text_Translation/master/chndomains.txt -O domain_primary_sample \
	&& wget https://raw.githubusercontent.com/17mon/china_ip_list/master/china_ip_list.txt -O ip_network_primary_sample \
	&& curl https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt | base64 -d | sort -u | sed '/^$\|@@/d'| sed 's#!.\+##; s#|##g; s#@##g; s#http:\/\/##; s#https:\/\/##;' | sed '/\*/d; /apple\.com/d; /sina\.cn/d; /sina\.com\.cn/d; /baidu\.com/d; /qq\.com/d' | sed '/^[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+$/d' | grep '^[0-9a-zA-Z\.-]\+$' | grep '\.' | sed 's#^\.\+##' | sort -u > /tmp/temp_gfwlist.txt \
	&& curl https://raw.githubusercontent.com/hq450/fancyss/master/rules/gfwlist.conf | sed 's/ipset=\/\.//g; s/\/gfwlist//g; /^server/d' > /tmp/temp_koolshare.txt \
	&& cat /tmp/temp_gfwlist.txt /tmp/temp_koolshare.txt | sort -u > /etc/overture/domain_alternative_sample

CMD /etc/overture/overture-linux-amd64 -c /etc/overture/config.json
