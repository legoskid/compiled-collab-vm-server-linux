#!/bin/sh
# defaults
tunnel_svc=lhr
while [ "$#" -gt 0 ]
do
    case "$1" in
        --help) echo "Usage: $0 <options>"
                echo 'Start script for cvm server, built by mkcvm'
                echo 'Options:'
                echo '--help    Print this help'
                echo '-t, --tunnel-service <service>'
                echo '    Choose a different tunneling service'
                echo '    Currently supported tunneling services:'
                echo '      none - do not run a tunnel'
                echo '      localhost.run - shorthand lhr'
                echo '      localtunnel (not tested yet) - shorthand lt'
                echo "    Default set by mkcvm: lhr"
                exit;;
        -t|--tunnel-service) 
                case "$2" in
                    none) tunnel_svc="none";;
                    localhost.run|lhr) tunnel_svc="lhr";;
                    localtunnel|lt) tunnel_svc="lt";;
                    *) echo "Unknown tunneling service $2"
                       exit 1;;
                esac
                shift 2;;
        *) echo "Unknown option $1. Use --help for help."
           exit 1;;
    esac
done
cd ~/cvm/final
./collab-vm-server 8080 &
# run tunnel
case "$tunnel_svc" in
    none) echo 'Running no tunneling service, as requested.';;
    lhr) ssh -R 80:localhost:8080 nokey@localhost.run;;
    lt) npx localtunnel --port 8080;;
esac
