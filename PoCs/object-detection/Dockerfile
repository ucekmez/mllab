FROM ubuntu:14.04
MAINTAINER ugur cekmez <ugur.cekmez@tubitak.gov.tr>
RUN apt-get update

RUN apt-get install -y git-core
RUN apt-get install -y gcc
RUN apt-get install -y build-essential

# download yolo model
RUN git clone https://github.com/pjreddie/darknet
WORKDIR /darknet
ADD ["./yolov3.weights", "/darknet/yolov3.weights"]
RUN /bin/bash -c "make"
ADD ["./run.sh", "/darknet/run.sh"]

RUN mkdir /data

#ENTRYPOINT ["./darknet", "detect", "cfg/yolov3.cfg", "yolov3.weights"]
ENTRYPOINT ["./run.sh"]
