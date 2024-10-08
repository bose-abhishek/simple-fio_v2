#==========================================================
# Creating and setting up the namespace
# ---------------------------------------------------------
namespace="simple-fio"
if [ `oc get project | grep ${namespace} | awk '{print $1}'` ]
then
        oc project ${namespace} > /dev/null
else
        echo "Creating project simple-fio"
        oc create namespace ${namespace}
        oc project ${namespace}

fi

#============================
# Check fio storage pod is up
#----------------------------
if [[ $(oc get pvc | grep fio-data-pvc | awk '{print $1}') != "fio-data-pvc" ]];
        then
        sc_type=$(oc get sc | grep cephfs | awk '{print $1}')
        export sc_type=${sc_type}
        envsubst < fio-data-pvc.yaml | oc create -f -
        #oc create -f fio-data-pvc.yaml
fi
if [[ $(oc get pods | grep fio-storage | awk '{print $1}') != "fio-storage" ]];
        then
        oc apply -f fio-storage.yaml
fi

