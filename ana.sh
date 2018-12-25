#!/bin/bash -
#===============================================================================
#
#          FILE: ana.sh
#
#         USAGE: ./ana.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Dr. Sandeep Sadanandan (sillyfellow), sillyfellow@whybenormal.org
#  ORGANIZATION: Kotaicode UG
#       CREATED: 10/20/2018 23:46:06
#      REVISION:  ---
#===============================================================================

set -o nounset                                  # Treat unset variables as an error
set -x


export ACCESSRESULTS=access_results
rm -rf ${ACCESSRESULTS}
mkdir -p ${ACCESSRESULTS}

grep '/core/' basketball_access.log | grep -v '"OPTIONS ' | cut -f 6,7,9 -d ' '  > /tmp/._tmp_access_temp.log
cat /tmp/._tmp_access_temp.log | grep "2..$" | cut -b 2- > ${ACCESSRESULTS}/success.log
cat /tmp/._tmp_access_temp.log | grep "3..$" | cut -b 2- > ${ACCESSRESULTS}/redirect.log
cat /tmp/._tmp_access_temp.log | grep "4..$" | cut -b 2- > ${ACCESSRESULTS}/clientwrong.log
cat /tmp/._tmp_access_temp.log | grep "5..$" | cut -b 2- > ${ACCESSRESULTS}/failed.log

export ERRORRESULTS=error_results
rm -rf ${ERRORRESULTS}
mkdir -p ${ERRORRESULTS}
grep '/core/' basketball_error.log | grep -v 'OPTIONS' | cut -f 2 -d '*' | cut -f 1,4 -d ',' | cut -f 2- -d ' ' | grep -v 'worker_connections are not enough' > ${ERRORRESULTS}/other_problems.log
grep '/core/' basketball_error.log | grep -v 'OPTIONS' | cut -f 2 -d '*' | cut -f 1,4 -d ',' | cut -f 2- -d ' ' | grep 'worker_connections are not enough' > ${ERRORRESULTS}/worker_connections.log
grep -v '/core/' basketball_error.log |  cut -f 2 -d ']' | cut -f 2 -d ':' | cut -f 1 -d ',' | cut -f 3- -d ' ' > ${ERRORRESULTS}/non_core_errors.log

export CORERESULTS=core_results
rm -rf ${CORERESULTS}
mkdir -p ${CORERESULTS}
export LOGDATESTART=`head -n 1  basketball_access.log  | cut -f 2 -d '[' | cut -f 1 -d ':' | tr '/' '\n' | tac | tr '\n' '-' | sed 's/Nov/11/g' | cut -b -10`
grep ":\"${LOGDATESTART}" combined.log | grep 'GET\|POST\|PUT\|DELETE' > /tmp/._tmp_core_reqs.log

# Think of end too?
# export LOGDATEEND=`tail -n 1  basketball_access.log | cut -f 2 -d '[' | cut -f 1 -d ':' | tr '/' '\n' | tac | tr '\n' '-' | sed 's/Nov/11/g' | cut -b -10`
# grep ":\"${LOGDATESTART}\|:\"${LOGDATEEND}" combined.log | grep 'GET\|POST\|PUT\|DELETE' > /tmp/._tmp_core_reqs.log

cat /tmp/._tmp_core_reqs.log | cut -f 2,3,4 -d ' ' > /tmp/._tmp_core.log
cat /tmp/._tmp_core.log | grep "2..$" > ${CORERESULTS}/success.log
cat /tmp/._tmp_core.log | grep "3..$" > ${CORERESULTS}/redirect.log
cat /tmp/._tmp_core.log | grep "4..$" > ${CORERESULTS}/clientwrong.log
cat /tmp/._tmp_core.log | grep "5..$" > ${CORERESULTS}/failed.log

export COUNTDIR=counts
rm -rf ${COUNTDIR}
mkdir -p ${COUNTDIR}
cat ${ACCESSRESULTS}/failed.log | sort | uniq -c  | sort -n > ${COUNTDIR}/access_failed.log
cat ${ACCESSRESULTS}/failed.log | wc -l >> ${COUNTDIR}/access_failed.log
cat ${ACCESSRESULTS}/success.log | sort | uniq -c  | sort -n > ${COUNTDIR}/access_success.log
cat ${ACCESSRESULTS}/success.log | wc -l >> ${COUNTDIR}/access_success.log

cat ${ERRORRESULTS}/other_problems.log | sort | uniq -c  | sort -n > ${COUNTDIR}/errors_failed.log
cat ${ERRORRESULTS}/other_problems.log | wc -l >> ${COUNTDIR}/errors_failed.log
cat ${ERRORRESULTS}/worker_connections.log | sort | uniq -c  | sort -n > ${COUNTDIR}/errors_workers_low.log
cat ${ERRORRESULTS}/worker_connections.log | wc -l >> ${COUNTDIR}/errors_workers_low.log
cat ${ERRORRESULTS}/non_core_errors.log | sort | uniq -c | sort -n > ${COUNTDIR}/errors_non_core.log
cat ${ERRORRESULTS}/non_core_errors.log | wc -l >> ${COUNTDIR}/errors_non_core.log

cat ${CORERESULTS}/failed.log | sort | uniq -c  | sort -n > ${COUNTDIR}/core_failed.log
cat ${CORERESULTS}/failed.log | wc -l >> ${COUNTDIR}/core_failed.log
cat ${CORERESULTS}/success.log | sort | uniq -c  | sort -n > ${COUNTDIR}/core_success.log
cat ${CORERESULTS}/success.log | wc -l >> ${COUNTDIR}/core_success.log

tail ${COUNTDIR}/core_* ${COUNTDIR}/access_* | grep 'GET\|POST\|PUT\|DELETE' | sort | uniq | rev | cut -f -3 -d ' ' | rev | sed 's|/core||g' | uniq > /tmp/._tmp_calls.log
while read line
do
    MS=`cat /tmp/._tmp_core_reqs.log | grep "${line}" | rev | cut -f 2 -d '}' | rev | cut -f 3 -d ' ' | awk '{ sum += $1; n++ } END { if (n > 0) print sum / n, ",", n, ",", sum; }'`
    echo -en "${MS} :${line}\n"
done < /tmp/._tmp_calls.log | sort -n > ${COUNTDIR}/call_times_in_ms.log
