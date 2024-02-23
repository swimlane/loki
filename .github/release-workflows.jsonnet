local lokiRelease = import 'workflows/main.jsonnet';
local build = lokiRelease.build;

local releaseLibRef = 'v1.11.2';
local checkTemplate = 'grafana/loki-release/.github/workflows/check.yml@%s' % releaseLibRef;
{
  'patch-release-pr.yml': std.manifestYamlDoc(
    lokiRelease.releasePRWorkflow(
      imageJobs={
        loki: build.image('loki', 'cmd/loki'),
        fluentd: build.image('fluentd', 'clients/cmd/fluentd', platform=['linux/amd64']),
        'fluent-bit': build.image('fluent-bit', 'clients/cmd/fluent-bit', platform=['linux/amd64']),
        logstash: build.image('logstash', 'clients/cmd/logstash', platform=['linux/amd64']),
        logcli: build.image('logcli', 'cmd/logcli'),
        'loki-canary': build.image('loki-canary', 'cmd/loki-canary'),
        'loki-operator': build.image('loki-operator', 'operator', context='release/operator', platform=['linux/amd64']),
        promtail: build.image('promtail', 'clients/cmd/promtail'),
        querytee: build.image('querytee', 'cmd/querytee', platform=['linux/amd64']),
      },
      buildImage='grafana/loki-build-image:0.29.3-go1.20.10',
      branches=['release-[0-9]+.[0-9]+.x'],
      checkTemplate=checkTemplate,
      golangCiLintVersion='v1.51.2',
      imagePrefix='grafana',
      releaseLibRef=releaseLibRef,
      releaseRepo='grafana/loki',
      skipArm=false,
      skipValidation=false,
      versioningStrategy='always-bump-patch',
    ), false, false
  ),
  'minor-release-pr.yml': std.manifestYamlDoc(
    lokiRelease.releasePRWorkflow(
      imageJobs={
        loki: build.image('loki', 'cmd/loki'),
        fluentd: build.image('fluentd', 'clients/cmd/fluentd', platform=['linux/amd64']),
        'fluent-bit': build.image('fluent-bit', 'clients/cmd/fluent-bit', platform=['linux/amd64']),
        logstash: build.image('logstash', 'clients/cmd/logstash', platform=['linux/amd64']),
        logcli: build.image('logcli', 'cmd/logcli'),
        'loki-canary': build.image('loki-canary', 'cmd/loki-canary'),
        'loki-operator': build.image('loki-operator', 'operator', context='release/operator', platform=['linux/amd64']),
        promtail: build.image('promtail', 'clients/cmd/promtail'),
        querytee: build.image('querytee', 'cmd/querytee', platform=['linux/amd64']),
      },
      buildImage='grafana/loki-build-image:0.29.3-go1.20.10',
      branches=['k[0-9]+'],
      checkTemplate=checkTemplate,
      golangCiLintVersion='v1.51.2',
      imagePrefix='grafana',
      releaseLibRef=releaseLibRef,
      releaseRepo='grafana/loki',
      skipArm=false,
      skipValidation=false,
      versioningStrategy='always-bump-minor',
    ), false, false
  ),
  'release.yml': std.manifestYamlDoc(
    lokiRelease.releaseWorkflow(
      branches=['release-[0-9]+.[0-9]+.x', 'k[0-9]+'],
      getDockerCredsFromVault=true,
      imagePrefix='grafana',
      releaseLibRef=releaseLibRef,
      releaseRepo='grafana/loki',
    ), false, false
  ),
}
