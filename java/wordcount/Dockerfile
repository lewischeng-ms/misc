FROM openjdk:8-jdk

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ssh rsync\
  && rm -rf /var/lib/apt/lists/*

RUN cd /root \
  && wget https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-2.8.0/hadoop-2.8.0.tar.gz \
  && tar zxvf hadoop-2.8.0.tar.gz \
  && rm -f hadoop-2.8.0.tar.gz

WORKDIR /root/hadoop-2.8.0

COPY input ./input
COPY patterns.txt .
RUN bin/hdfs dfs -mkdir -p /user/lewis/input \
  && bin/hdfs dfs -put ./input/* /user/lewis/input \
  && bin/hdfs dfs -put ./patterns.txt /user/lewis \
  && bin/hdfs dfs -ls input \
  && bin/hdfs dfs -cat input/file01 \
  && bin/hdfs dfs -cat input/file02 \
  && bin/hdfs dfs -cat patterns.txt

COPY WordCount2.java ./

ENV HADOOP_CLASSPATH $JAVA_HOME/lib/tools.jar

RUN bin/hadoop com.sun.tools.javac.Main WordCount2.java \
  && jar cf wc.jar WordCount2*.class

CMD bin/hadoop jar wc.jar WordCount2 -Dwordcount.case.sensitive=false /user/lewis/input /user/lewis/output -skip /user/lewis/patterns.txt \
# CMD bin/hadoop jar wc.jar WordCount2 -Dwordcount.case.sensitive=true /user/lewis/input /user/lewis/output -skip /user/lewis/patterns.txt \
# CMD bin/hadoop jar wc.jar WordCount2 /user/lewis/input /user/lewis/output \
  && bin/hdfs dfs -cat /user/lewis/output/part-r-00000