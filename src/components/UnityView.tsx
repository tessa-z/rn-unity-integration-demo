import React from 'react';
import {
  requireNativeComponent,
  UIManager,
  findNodeHandle,
  Platform,
  NativeSyntheticEvent,
  ViewStyle,
} from 'react-native';

interface UnityMessage {
  message: string;
}

type ReactNativeUnityViewProps = {
  onUnityMessage?: (event: NativeSyntheticEvent<UnityMessage>) => void;
  style?: ViewStyle;
};

const ComponentName = 'ReactNativeUnityView';

const ReactNativeUnityView =
  requireNativeComponent<ReactNativeUnityViewProps>(ComponentName);

export class UnityView extends React.Component<ReactNativeUnityViewProps> {
  static defaultProps = {};

  constructor(props: ReactNativeUnityViewProps) {
    super(props);
  }

  public postMessage(gameObject: string, methodName: string, message: string) {
    UIManager.dispatchViewManagerCommand(
      findNodeHandle(this),
      this.getCommand('postMessage'),
      [gameObject, methodName, message],
    );
  }

  private getCommand(cmd: string): any {
    if (Platform.OS === 'ios') {
      return UIManager.getViewManagerConfig('ReactNativeUnityView').Commands[
        cmd
      ];
    } else {
      return cmd;
    }
  }

  private getProps() {
    return {
      ...this.props,
    };
  }

  public render() {
    return <ReactNativeUnityView {...this.getProps()} />;
  }
}
