# -*- coding: utf-8 -*-
import requests
from xml.sax.saxutils import escape as xmlescape


class BrainVISAJenkins:
    '''
    Wrapper to access Jenkins server of Brain12VISA and push bv_maker results
    '''

    job_xml = '''<?xml version='1.1' encoding='UTF-8'?>
    <hudson.model.ExternalJob plugin="external-monitor-job@1.7">
    <actions/>
    <description>{description}</description>
    <keepDependencies>false</keepDependencies>
    <properties>
        <jenkins.model.BuildDiscarderProperty>
        <strategy class="hudson.tasks.LogRotator">
            <daysToKeep>-1</daysToKeep>
            <numToKeep>20</numToKeep>
            <artifactDaysToKeep>-1</artifactDaysToKeep>
            <artifactNumToKeep>-1</artifactNumToKeep>
        </strategy>
        </jenkins.model.BuildDiscarderProperty>
    </properties>
    </hudson.model.ExternalJob>
    '''

    build_xml = ('<run>'
                 '<log encoding="hexBinary">{hex_log}</log>'
                 '<result>{result:d}</result>'
                 '<duration>{duration:d}</duration>'
                 '<displayName>{build}</displayName>'
                 '<description>{description}</description>'
                 '</run>')

    def __init__(self, server, login, password):
        '''
        server = URL of the Jenkins server
        login = username to use for Jenkins authentication
        password = password or token for authentication
        '''
        self.server = server
        self.login = login
        self.password = password

    def get(self, route, **kwargs):
        return requests.get(f'{self.server}/{route}',
                            auth=(self.login, self.password),
                            **kwargs)

    def post(self, route, **kwargs):
        return requests.post(f'{self.server}/{route}',
                             auth=(self.login, self.password),
                             **kwargs)

    def delete(self, route, **kwargs):
        return requests.delete(f'{self.server}/{route}',
                               auth=(self.login, self.password),
                               **kwargs)

    def job_exists(self, environment):
        r = self.get(f'/job/{environment}/api/json')
        if r.status_code == 404:
            return False
        r.raise_for_status()
        return True

    def create_job(self, environment,
                   **metadata):
        '''
        Create a jenkins job representing a task performed in a casa_distro
        environment.The type of the job created is "external task" therefore
        the corresponding plugin must be installed on the server. The job is
        configured to keep only the 20 last build logs (others are destroyed).

        environment : name of the casa_distro environment.
        metadata     : values that are added to the description of the job
        '''
        description = xmlescape('\n'.join(
            [f'environment = {environment}']
            + ['{} = {}'.format(*i) for i in metadata.items()]))
        r = self.post('createItem',
                      params={'name': environment},
                      headers={'Content-Type': 'application/xml'},
                      data=self.job_xml.format(description=description))
        r.raise_for_status()

    def delete_job(self, job):
        r = self.delete(f'job/{job}/')
        r.raise_for_status()

    def jobs(self):
        r = self.get('api/json')
        r.raise_for_status()
        return [i['name'] for i in r.json()['jobs']]

    def create_build(self, environment, task, result,
                     log, duration=None, description=None):
        '''
        Add a build report related

        environment : name of the casa_distro environment.
        task        : name of the task that is performed by this build
                      (e.g. src, configure, build, etc.)
        result      : integer value representing the result of the build
                      any non-zero value means failure
        log         : console output of the build
        duration    : (optional) duration of the build in milliseconds
        description : (optional) description text attached to the build
        '''
        if not isinstance(log, bytes):
            log = log.encode('UTF8')
        r = self.post(f'job/{environment}/postBuildResult',
                      headers={'Content-Type': 'application/xml'},
                      data=self.build_xml.format(
                          build=xmlescape(str(task)),
                          hex_log=log.hex(),
                          result=result or 0,
                          duration=int(round(duration)) if duration else 0,
                          description=xmlescape(description or ''),
                      ))
        r.raise_for_status()
