htmlfiles="src/main/resources/inputpages/files/html"

# Google ...
#mvn clean install "exec:java" -Durl=https://www.google.com -Dpackage="com.dmcc.sample.pages.google" -Dsrc.root=../pgenexamples/src/test/java -Dresources.root=../pgenexamples/src/test/resources

# BJSS timesheets ...
#mvn clean install "exec:java" -Durl=https://bjss.my.salesforce.com -Dpackage="com.dmcc.sample.pages.timesheets" -Dsrc.root=../pgenexamples/src/test/java -Dresources.root=../pgenexamples/src/test/resources

# Ocado
#mvn clean install "exec:java" -Durl=https://www.ocado.com/webshop/quickReg.do -Dpackage="com.dmcc.sample.pages.ocado" -Dsrc.root=../pgenexamples/src/test/java -Dresources.root=../pgenexamples/src/test/resources

# Expedia
#mvn clean install "exec:java" -Durl=https://www.expedia.co.uk -Dpackage="com.dmcc.sample.pages.expedia" -Dsrc.root=../pgenexamples/src/test/java -Dresources.root=../pgenexamples/src/test/resources

# HSBC 
#mvn clean install "exec:java" -Duse.file=true -Durl=https://www.hsbc.co.uk -Dfile=hsbc.html -Dpackage="com.dmcc.sample.pages.hsbc" -Dsrc.root=../pgenexamples/src/test/java -Dresources.root=../pgenexamples/src/test/resources

# LLoyds Bank
#mvn clean install "exec:java" -Duse.file=true -Dfile=lloydsbank.html -Durl=https://www.lloydsbank.com -Dpackage="com.dmcc.sample.pages.lloydsbank" -Dsrc.root=../pgenexamples/src/test/java -Dresources.root=../pgenexamples/src/test/resources

# Instagram
#mvn clean install "exec:java" -Duse.file=true -Dfile=instagram.html -Durl=https://www.instagram.com -Dpackage="com.dmcc.sample.pages.instagram" -Dsrc.root=../pgenexamples/src/test/java -Dresources.root=../pgenexamples/src/test/resources

#  Last Minute
#mvn clean install "exec:java" -Duse.file=true -Dfile=lastminute.html -Durl=https://www.lastminute.com -Dpackage="com.dmcc.sample.pages.lastminute" -Dsrc.root=../pgenexamples/src/test/java -Dresources.root=../pgenexamples/src/test/resources

function generate(){

	url="${1}"
	package="${2}"
	root="${3}"
	file="${4}"

	if [[ ! -z "${file}" ]]
	then
		usefilearg="-Duse.file=true"
	else
		unset usefilearg
	fi

	echo "url=${url}"

	#mvn clean install "exec:java" -Duse.file=true -Dfile=lastminute.html -Durl=${url} -Dpackage="com.dmcc.sample.pages.lastminute" -Dsrc.root=${root}/src/test/java -Dresources.root=${root}/src/test/resources
}

generate "https://www.lastminute.com"
